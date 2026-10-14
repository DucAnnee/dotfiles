#!/usr/bin/env bash
set -euo pipefail
# Source the shared helpers; need fails early if a required command is missing.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
need fc-cache
if [[ $DISTRO == arch ]]; then
    # Use a packaged font on Arch; else uses the upstream archive on Ubuntu.
    sudo pacman -S --needed --noconfirm ttf-cascadia-code-nerd
else
    need curl
    need unzip
    temp_dir
    download "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERD_FONTS_VERSION/CascadiaCode.zip" "$WORK_DIR/CascadiaCode.zip"
    unzip -q "$WORK_DIR/CascadiaCode.zip" -d "$WORK_DIR/fonts"
    font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/CaskaydiaCove"
    mkdir -p "$font_dir"
    # Quoting '*.ttf' lets find match the pattern instead of the shell expanding it.
    # -exec runs install for each match; {} is the matched filename and \; ends
    # that command. Mode 644 allows everyone to read, and only the owner to write.
    find "$WORK_DIR/fonts" -type f -name '*.ttf' -exec install -m 644 '{}' "$font_dir/" \;
fi
# Rebuild fontconfig's cache so applications can discover the installed font.
fc-cache -f
