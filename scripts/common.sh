#!/usr/bin/env bash
# Shared paths and a few helpers; modules are executable on their own.
# Variables are consumed by the scripts that source this file.
# shellcheck disable=SC2034
# All modules share these Bash error settings; see setup.sh for their meaning.
set -euo pipefail
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=config.env
source "$ROOT/config.env"
# name() { ...; } defines a function. "$*" joins its arguments into one string.
# printf uses %s to insert strings without interpreting them as formatting.
log() { printf '\n==> %s\n' "$*"; }
# >&2 sends output to stderr. exit 1 signals failure; exit 0 signals success.
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
# [[ ... ]] tests a condition; || calls die only when the test is false.
[[ $(id -u) != 0 ]] || die 'Run as your normal user, not root or sudo.'
[[ $(uname -s) == Linux ]] || die 'This setup supports Linux only.'
# shellcheck disable=SC1091
source /etc/os-release
DISTRO=$ID
case $ID in
    arch) DISTRO_MANAGER=pacman ;;
    ubuntu)
        DISTRO_MANAGER=apt
        # %% removes the longest matching suffix: 24.04 becomes 24.
        # -ge means "greater than or equal to" for integer comparisons.
        [[ ${VERSION_ID%%.*} -ge 24 ]] || die 'Ubuntu 24.04 or newer is required.'
        ;;
    *) die "Unsupported distribution: $ID (supported: Arch Linux, Ubuntu)" ;;
esac
case $(uname -m) in
    x86_64) ARCH=x86_64; RELEASE_ARCH=x86_64 ;;
    aarch64|arm64) ARCH=arm64; RELEASE_ARCH=arm64 ;;
    *) die "Unsupported architecture: $(uname -m)" ;;
esac
[[ $DISTRO != arch || $ARCH == x86_64 ]] || die 'Official Arch repositories support x86_64; Arch Linux ARM is a separate distribution.'
for option in INSTALL_PNPM INSTALL_MAVEN INSTALL_DOCKER INSTALL_SNAP; do
    # ${!option} is indirect expansion: read the variable named by option.
    [[ ${!option} == 0 || ${!option} == 1 ]] || die "$option must be 0 or 1"
done
BIN_DIR="$HOME/.local/bin"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dev-setup"
# export makes a variable available to child processes. PATH is colon-separated.
export PATH="$BIN_DIR:${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
# sed removes comments, trims whitespace, and deletes blank lines in a list.
# Inside a function, $1 is the function's first argument (such as apt).
packages() { sed -e 's/#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$ROOT/packages/$1.txt"; }
# command -v checks command availability; >/dev/null discards its normal output.
need() { command -v "$1" >/dev/null || die "Missing $1; run bash setup.sh --only system first."; }
download() { curl --fail --location --show-error --silent --retry 3 "$1" -o "$2"; }
temp_dir() {
    # mktemp -d creates a unique directory. trap registers an exit cleanup.
    # Single quotes defer expansion of WORK_DIR until the cleanup runs.
    WORK_DIR=$(mktemp -d)
    trap 'rm -rf -- "$WORK_DIR"' EXIT
}
# Verify one downloaded asset against its upstream release manifest.
check_asset() {
    # local keeps these variables inside the function. awk selects the digest
    # whose filename field matches the asset; -v supplies a variable to awk.
    local asset=$1 manifest=$2 digest
    digest=$(awk -v name="$asset" '$2 == name || $2 == "*" name {print $1}' "$WORK_DIR/$manifest")
    # =~ tests a regular expression: exactly 64 hexadecimal characters.
    [[ $digest =~ ^[[:xdigit:]]{64}$ ]] || die "No unique SHA256 found for $asset"
    # | passes printf's output to sha256sum as standard input.
    printf '%s  %s\n' "$digest" "$WORK_DIR/$asset" | sha256sum --check --status || die "Checksum mismatch: $asset"
}
