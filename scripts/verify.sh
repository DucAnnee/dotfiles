#!/usr/bin/env bash
set -euo pipefail
# Load settings so verification uses the same versions and optional flags.
# shellcheck source=scripts/common.sh
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
failed=0
# "$@" runs the arguments as a command, keeping each argument separate.
# An if condition handles failures, letting us report every failed check.
check() {
    if "$@" >/dev/null 2>&1; then
        printf 'OK    %s\n' "$*"
    else
        printf 'FAIL  %s\n' "$*" >&2
        # Keep a failure flag rather than exiting at the first missing tool.
        failed=1
    fi
}
for tool in nvim wezterm zsh tmux sesh fzf zoxide git gh curl wget rg fd bat jq unzip zip gcc g++ clang make cmake pkg-config gdb shellcheck uv mise starship eza direnv ssh dig rsync git-lfs; do
    check command -v "$tool"
done
# Check actual runtime commands as well as their presence on PATH.
check uv python find "$PYTHON_VERSION"
check nvim --version
check sesh --version
check gh --version
check mise exec -- node --version
check mise exec -- npm --version
check mise exec -- tsc --version
check mise exec -- java -version
check mise exec -- javac -version
check mise exec -- keytool -help
# Only check optional tools when their installation switches are enabled.
[[ $INSTALL_PNPM == 0 ]] || check mise exec -- pnpm --version
[[ $INSTALL_MAVEN == 0 ]] || check mise exec -- mvn --version
if [[ $INSTALL_DOCKER == 1 ]]; then
    check docker --version
    check docker compose version
    check systemctl is-active --quiet docker
fi
if [[ $INSTALL_SNAP == 1 ]]; then
    # read -r reads a literal line each time; the loop ends at end-of-file.
    # The process substitution after done supplies the selected application list.
    while read -r app; do
        read -r -a args <<< "$app"
        check snap list "${args[0]}"
    done < <(packages snap)
fi
# The pipe sends font families to grep; its exit status reports a match.
if fc-list : family | grep 'CaskaydiaCove Nerd Font' >/dev/null; then
    printf 'OK    CaskaydiaCove Nerd Font\n'
else
    printf 'FAIL  CaskaydiaCove Nerd Font\n' >&2
    failed=1
fi
# Return 0 if all checks passed, or 1 if any check failed.
exit "$failed"
