#!/usr/bin/env bash
set -euo pipefail
# Load common functions and settings, including the optional Snap switch.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
# { ...; } groups commands in the current shell. || executes the group only
# when the preceding test fails; exit 0 treats a disabled component as success.
[[ $INSTALL_SNAP == 1 ]] || { log 'Snap disabled; set INSTALL_SNAP=1 to enable.'; exit 0; }
# mapfile -t reads lines into an array; ${#apps[@]} counts its elements.
mapfile -t apps < <(packages snap)
((${#apps[@]})) || { log 'No Snap applications selected in packages/snap.txt.'; exit 0; }
# Validate the small file format before making changes.
# =~ tests a regex: ^ and $ anchor it, and (...) with ? makes --classic optional.
for app in "${apps[@]}"; do
    [[ $app =~ ^[a-z0-9][a-z0-9-]*([[:space:]]+--classic)?$ ]] || die "Invalid Snap entry: $app"
done
if [[ $DISTRO == ubuntu ]]; then
    sudo apt-get update
    sudo apt-get install -y snapd
elif ! command -v snap >/dev/null; then
    die 'Arch snapd is in the AUR. Install snapd manually, then rerun this module; core setup needs no AUR.'
fi
sudo systemctl enable --now snapd.socket
# Wait for snapd's initial setup to finish before installing applications.
sudo snap wait system seed.loaded
for app in "${apps[@]}"; do
    # <<< feeds a string to stdin; read -a splits fields into an array.
    # -r keeps backslashes literal. This does not evaluate the string as code.
    read -r -a args <<< "$app"
    # >/dev/null hides stdout; 2>&1 sends stderr to the same place.
    # ${args[0]} is the first array item: the application's name.
    if snap list "${args[0]}" >/dev/null 2>&1; then
        log "Snap already installed: ${args[0]}"
    else
        sudo snap install "${args[@]}"
    fi
done
