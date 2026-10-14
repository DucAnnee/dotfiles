#!/usr/bin/env bash
set -euo pipefail
# Load common settings/functions and stop if the detected OS is not Arch.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
[[ $DISTRO == arch ]] || die 'pacman.sh requires Arch Linux.'
need sudo
# Read package-list lines into an array without their trailing newlines.
# <(...) supplies the output of packages pacman as an input file for mapfile.
mapfile -t pkgs < <(packages pacman)
# +=(...) appends items. || runs the append only if the flag is not 0.
[[ $INSTALL_MAVEN == 0 ]] || pkgs+=(maven)
[[ $INSTALL_DOCKER == 0 ]] || pkgs+=(docker docker-compose docker-buildx)
# Full upgrade avoids unsupported partial upgrades on Arch.
# -Syu refreshes package indexes and upgrades; --needed skips current packages.
# "${pkgs[@]}" passes each array element as a separate argument.
sudo pacman -Syu --needed --noconfirm "${pkgs[@]}"
if [[ $INSTALL_DOCKER == 1 ]]; then
    # This branch runs only when Docker was selected.
    sudo systemctl enable --now docker
    log 'Docker enabled. Use sudo docker; no docker group membership was added.'
fi
