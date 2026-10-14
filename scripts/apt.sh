#!/usr/bin/env bash
set -euo pipefail
# source loads shared settings and helpers; $(dirname ...) finds this script's
# directory. The shellcheck comment below tells the linter where that file is.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
[[ $DISTRO == ubuntu ]] || die 'apt.sh requires Ubuntu.'
need sudo
# Refresh apt's index, then install the tools needed to add a package source.
# sudo runs with elevated privileges; -y accepts package-manager prompts.
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg software-properties-common
sudo add-apt-repository -y universe
temp_dir
# Upstream WezTerm repository, with a scoped signing key.
download https://apt.fury.io/wez/gpg.key "$WORK_DIR/wezterm.key"
gpg --batch --yes --dearmor -o "$WORK_DIR/wezterm-fury.gpg" "$WORK_DIR/wezterm.key"
sudo install -m 644 "$WORK_DIR/wezterm-fury.gpg" /usr/share/keyrings/wezterm-fury.gpg
# > writes stdout to a file, replacing its contents. The quoted repository line
# is literal text; printf adds the newline with its format string.
printf '%s\n' 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' > "$WORK_DIR/wezterm.list"
sudo install -m 644 "$WORK_DIR/wezterm.list" /etc/apt/sources.list.d/wezterm.list
sudo apt-get update
# mapfile reads lines into an array; -t removes their trailing newlines.
# <(...) makes command output readable as a file; < feeds it to mapfile.
mapfile -t pkgs < <(packages apt)
# +=(...) appends array items. || appends an optional item when the test fails.
pkgs+=(wezterm)
[[ $INSTALL_MAVEN == 0 ]] || pkgs+=(maven)
# Use Ubuntu's maintained Engine and Compose packages.
[[ $INSTALL_DOCKER == 0 ]] || pkgs+=(docker.io docker-compose-v2 docker-buildx)
# Quoting ${pkgs[@]} passes each package as a separate argument.
sudo apt-get install -y "${pkgs[@]}"
mkdir -p "$BIN_DIR"
# Ubuntu renames these executables; provide the conventional names.
# ln -s creates a symbolic link; -f replaces an existing destination and
# -n prevents following a destination link that points to a directory.
ln -sfn /usr/bin/fdfind "$BIN_DIR/fd"
ln -sfn /usr/bin/batcat "$BIN_DIR/bat"
if [[ $INSTALL_DOCKER == 1 ]]; then
    # enable starts Docker on future boots; --now also starts it immediately.
    sudo systemctl enable --now docker
    log 'Docker enabled. Use sudo docker; no docker group membership was added.'
fi
