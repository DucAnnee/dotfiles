#!/usr/bin/env bash
# The shebang selects Bash when this file is executed directly.
# -e stops on unhandled failures, -u rejects unset variables, and pipefail
# makes a pipeline fail if any command in it fails. Conditional checks can
# handle failures explicitly instead of stopping the script.
set -euo pipefail
# $(...) captures command output. BASH_SOURCE[0] is this script's filename;
# dirname and cd find its directory even when called from somewhere else.
# Double quotes preserve paths with spaces; -- ends command options.
ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# $1 is the first argument. ${1:-} uses an empty string if it is unset or empty.
if [[ ${1:-} == --help ]]; then
    # A heredoc feeds multiple lines to cat. Quoting 'HELP' prevents expansion
    # of variables and command substitutions inside the help text.
    cat <<'HELP'
Usage: bash setup.sh [--plan] [--only STEP]
Steps: system, pacman, apt, snap, runtimes, user-tools, fonts, verify
Run as your normal user; system installers use sudo.
Edit config.env, or override settings: INSTALL_DOCKER=1 bash setup.sh
--plan prints the selected steps without installing anything.
HELP
    exit 0
fi
# shellcheck source=scripts/common.sh
# source runs another file in this shell, sharing its variables and functions.
source "$ROOT/scripts/common.sh"
plan=0
only=
# $# counts remaining arguments; ((...)) evaluates an arithmetic expression.
# case selects a matching argument, ;; ends a branch, and * matches anything.
# shift removes one argument; shift 2 removes an option and its value.
while (($#)); do
    case $1 in
        --plan) plan=1; shift ;;
        --only) [[ $# -ge 2 ]] || die '--only needs a step'; only=$2; shift 2 ;;
        *) die "Unknown argument: $1 (see --help)" ;;
    esac
done
# Parentheses create a Bash array. A later assignment replaces the whole array.
steps=("$DISTRO_MANAGER" runtimes user-tools fonts verify)
# A || B runs B only when A fails; here it adds Snap when the flag is enabled.
[[ $INSTALL_SNAP == 0 ]] || steps=("$DISTRO_MANAGER" runtimes user-tools fonts snap verify)
# [[ -n ... ]] checks whether a string is nonempty.
if [[ -n $only ]]; then
    [[ $only != system ]] || only=$DISTRO_MANAGER
    case $only in
        pacman|apt|snap|runtimes|user-tools|fonts|verify) steps=("$only") ;;
        *) die "Unknown step: $only" ;;
    esac
fi
log "$DISTRO / $ARCH; Python $PYTHON_VERSION, Node $NODE_VERSION, Java $JAVA_VERSION"
# "${array[@]}" expands to one quoted argument per array item.
for step in "${steps[@]}"; do
    log "Step: $step"
    # Planning logs the steps; otherwise bash runs each module in a new shell.
    [[ $plan == 1 ]] || bash "$ROOT/scripts/$step.sh"
done
