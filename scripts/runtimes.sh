#!/usr/bin/env bash
set -euo pipefail
# Load shared settings, check curl, and prepare a temporary download directory.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
need curl
temp_dir
mkdir -p "$BIN_DIR"
# ! negates an exit status: this branch runs when uv cannot be found on PATH.
# >/dev/null hides the path that command -v would normally print.
if ! command -v uv >/dev/null; then
    download https://astral.sh/uv/install.sh "$WORK_DIR/uv-install.sh"
    # NAME=value before a command sets variables only for that command and
    # its children. These tell the installer where to put uv and avoid PATH edits.
    UV_INSTALL_DIR="$BIN_DIR" UV_NO_MODIFY_PATH=1 sh "$WORK_DIR/uv-install.sh"
fi
if ! command -v mise >/dev/null; then
    download https://mise.run "$WORK_DIR/mise-install.sh"
    MISE_INSTALL_PATH="$BIN_DIR/mise" sh "$WORK_DIR/mise-install.sh"
fi
# Development Python stays managed by uv, separate from system Python.
uv python install "$PYTHON_VERSION"
# Quoted variables expand without splitting on spaces. mise use --global saves
# the default runtime selections; reshim regenerates command-launching shims.
mise use --global "node@$NODE_VERSION" "java@$JAVA_VERSION"
mise reshim
# -- separates mise's options from the command run in its runtime environment.
mise exec -- npm install --global "typescript@$TYPESCRIPT_VERSION"
# if ...; then ...; fi runs a block only when the condition succeeds.
if [[ $INSTALL_PNPM == 1 ]]; then
    mise exec -- npm install --global "pnpm@$PNPM_VERSION"
fi
mise reshim
