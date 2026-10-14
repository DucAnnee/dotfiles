#!/usr/bin/env python3
"""Non-installing checks for a standalone tool and package installer."""
from pathlib import Path
import subprocess
import tempfile
import hashlib

ROOT = Path(__file__).resolve().parents[1]


def run(args, env, expected=0):
    result = subprocess.run(args, cwd=ROOT, env=env, capture_output=True,
                            text=True, timeout=30)
    assert result.returncode == expected, result.stdout + result.stderr
    return result.stdout


with tempfile.TemporaryDirectory(prefix="dev-setup-smoke-") as directory:
    temporary = Path(directory)
    home = temporary / "home"
    home.mkdir()
    env = {
        "HOME": str(home), "PATH": "/usr/bin:/bin", "TERM": "xterm-256color",
        "XDG_CONFIG_HOME": str(home / ".config"),
        "XDG_DATA_HOME": str(home / ".local/share"),
        "XDG_STATE_HOME": str(home / ".local/state"),
        "XDG_CACHE_HOME": str(home / ".cache"),
    }
    output = run(["bash", "setup.sh", "--plan"], env)
    assert "Step: runtimes" in output and "Step: snap" not in output
    assert "configure" not in output
    optional = dict(env, INSTALL_SNAP="1", INSTALL_DOCKER="1")
    assert "Step: snap" in run(["bash", "setup.sh", "--plan"], optional)
    output = run(["bash", "setup.sh", "--plan", "--only", "fonts"], env)
    assert output.count("Step:") == 1 and "Step: fonts" in output
    run(["bash", "setup.sh", "--only", "unknown"], env, expected=1)
    run(["bash", "setup.sh", "--only", "configure"], env, expected=1)
    run(["bash", "setup.sh", "--only"], env, expected=1)
    run(["bash", "setup.sh", "--plan"], dict(env, INSTALL_PNPM="yes"), expected=1)

    assert not list(home.iterdir()), "Planning must not write user files"

    # Validate both acceptance and rejection of upstream checksum manifests.
    asset = temporary / "asset.tar.gz"
    asset.write_bytes(b"test-release")
    manifest = temporary / "checksums.txt"
    digest = hashlib.sha256(asset.read_bytes()).hexdigest()
    manifest.write_text(f"{digest}  {asset.name}\n")
    checksum_env = dict(env, WORK_DIR=str(temporary))
    check = 'source scripts/common.sh; check_asset asset.tar.gz checksums.txt'
    run(["bash", "-c", check], checksum_env)
    asset.write_bytes(b"corrupted-release")
    run(["bash", "-c", check], checksum_env, expected=1)

    # Verification must work without user configuration and report failures.
    commands = """nvim wezterm zsh tmux sesh fzf zoxide git gh curl wget rg fd bat jq
        unzip zip gcc g++ clang make cmake pkg-config gdb shellcheck uv mise
        starship eza direnv ssh dig rsync git-lfs fc-list""".split()
    bin_dir = home / ".local/bin"
    bin_dir.mkdir(parents=True)
    stub = temporary / "stub"
    stub.write_text("#!/bin/bash\n"
                    'if [[ ${0##*/} == "${FAIL_TOOL:-}" ]]; then exit 1; fi\n'
                    "if [[ ${0##*/} == fc-list ]]; then printf 'CaskaydiaCove Nerd Font\\n'; fi\n"
                    "exit 0\n")
    stub.chmod(0o755)
    for name in commands:
        (bin_dir / name).symlink_to(stub)
    run(["bash", "scripts/verify.sh"], env)
    run(["bash", "scripts/verify.sh"], dict(env, FAIL_TOOL="mise"), expected=1)
    assert not (home / ".config").exists(), "Verification must not need user configs"

print("PASS: routing, options, read-only planning, checksums, tool-only verification")
