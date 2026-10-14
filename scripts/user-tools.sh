#!/usr/bin/env bash
set -euo pipefail
# Shared helpers handle distro detection, downloads, and temporary-file cleanup.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
need curl
need tar
temp_dir
# mkdir -p also creates missing parents and accepts directories that exist.
mkdir -p "$BIN_DIR" "$DATA_DIR"
# Install only when command -v cannot find an existing Starship executable.
if ! command -v starship >/dev/null; then
    download https://starship.rs/install.sh "$WORK_DIR/starship-install.sh"
    sh "$WORK_DIR/starship-install.sh" --yes --bin-dir "$BIN_DIR"
fi
if [[ $DISTRO == ubuntu ]]; then
    # Variables build the archive filename and URL for the detected architecture.
    archive="nvim-linux-$ARCH.tar.gz"
    download "https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/$archive" "$WORK_DIR/$archive"
    mkdir -p "$WORK_DIR/nvim" "$DATA_DIR/nvim"
    # tar: -x extracts, -z handles gzip, -f names the archive, -C selects the
    # output directory. --strip-components=1 removes the top-level path segment.
    tar -xzf "$WORK_DIR/$archive" -C "$WORK_DIR/nvim" --strip-components=1
    # Keep the runtime beside its executable; copying bin/nvim alone breaks it.
    # cp -a preserves attributes and copies recursively; /. includes all contents.
    cp -a "$WORK_DIR/nvim/." "$DATA_DIR/nvim/"
    ln -sfn "$DATA_DIR/nvim/bin/nvim" "$BIN_DIR/nvim"
fi
archive="sesh_Linux_$RELEASE_ARCH.tar.gz"
base="https://github.com/joshmedeski/sesh/releases/download/v$SESH_VERSION"
download "$base/$archive" "$WORK_DIR/$archive"
# ${...} delimits a variable name beside literal characters such as underscores.
manifest="sesh_${SESH_VERSION}_checksums.txt"
download "$base/$manifest" "$WORK_DIR/$manifest"
check_asset "$archive" "$manifest"
mkdir -p "$WORK_DIR/sesh"
tar -xzf "$WORK_DIR/$archive" -C "$WORK_DIR/sesh"
# install copies the executable and sets its mode: 755 permits everyone to run it,
# while only its owner can write it (7 = read/write/execute, 5 = read/execute).
install -m 755 "$WORK_DIR/sesh/sesh" "$BIN_DIR/sesh"
