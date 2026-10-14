# Linux development setup

Install development tools and packages on a new Linux machine with one command:

```bash
bash setup.sh
```

Supported: Arch Linux x86_64 and Ubuntu 24.04 or newer on x86_64/ARM64.
Run from the directory containing `setup.sh` as a normal user with sudo access
and an internet connection. System packages use pacman or apt; user tools install
under `~/.local/bin`. The scripts only install and verify tools and packages.

## Options

Edit `config.env` to select versions and optional components. Environment
variables override the defaults:

```bash
bash setup.sh --plan
INSTALL_PNPM=1 INSTALL_MAVEN=1 INSTALL_DOCKER=1 bash setup.sh
```

Python defaults to 3.12, Node.js to LTS, and Java to Temurin 25 LTS.
TypeScript is included. pnpm, Maven, Docker, and Snap are disabled by default.
Use exact versions in `config.env` when repeatable version selection is needed.

## Installed tools

- Neovim, WezTerm, zsh, tmux, sesh, fzf, and zoxide.
- Git, Git LFS, GitHub CLI (`gh`), curl, wget, ripgrep, fd, bat, jq, zip, and unzip.
- GCC/G++, Clang, make, CMake, pkg-config, GDB, and ShellCheck.
- uv and Python; mise, Node.js/npm, TypeScript, and the Temurin JDK.
- CaskaydiaCove Nerd Font.
- Starship, eza, direnv, SSH, clipboard utilities, dig, and rsync.

Arch uses official distribution packages where available. Ubuntu WezTerm uses
its [upstream apt repository](https://wezterm.org/install/linux.html#using-the-apt-repo),
and Ubuntu Neovim uses the [stable binary archive](https://neovim.io/doc/install/),
including its runtime. sesh uses a pinned release with SHA256 verification.
Arch installs the Nerd Font package; Ubuntu downloads the upstream font archive.

[uv](https://docs.astral.sh/uv/getting-started/installation/) manages development
Python with normal `.venv` defaults. [mise](https://mise.jdx.dev/getting-started)
manages Node.js and Java. The JDK includes `java`, `javac`, and `keytool`.

To use user-installed commands in a shell, add their directories to PATH:

```bash
export PATH="$HOME/.local/bin:${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"
```

Runtime commands also work through `mise exec --`, such as
`mise exec -- node --version` and `mise exec -- java -version`.

## Individual modules

Modules can run independently with Bash from any directory once dependencies
are available. `--only system` selects the detected package manager.

| Command | Purpose |
| --- | --- |
| `bash setup.sh --only system` | System packages and optional Maven/Docker |
| `bash scripts/runtimes.sh` | Python, Node.js, Java, TypeScript, optional pnpm |
| `bash scripts/user-tools.sh` | Starship, Ubuntu Neovim, and sesh |
| `bash scripts/fonts.sh` | Nerd Font and font cache |
| `bash scripts/snap.sh` | Selected Snap applications |
| `bash scripts/verify.sh` | Check installed commands, runtimes, and font |

Snap requires `INSTALL_SNAP=1` and applications selected in `packages/snap.txt`.
An empty list installs nothing. Ubuntu installs snapd as needed; Arch requires
snapd to be installed separately using its documented upstream installation.

Docker uses distribution Engine, Compose, and Buildx packages and enables the
daemon. Use `sudo docker`; setup does not add docker group membership.

Installation stops at the first failed module. Fix the reported problem and
rerun the module or entry command. Reruns reuse installed packages and replace
downloaded tools; floating versions may update. Arch performs a full system
upgrade to avoid partial upgrades. Ubuntu enables Universe.

## Validation

```bash
for script in setup.sh scripts/*.sh; do bash -n "$script"; done
shellcheck -x setup.sh scripts/*.sh
python3 tests/smoke.py
bash setup.sh --plan
```

Smoke checks use temporary files and mocked commands without installing packages.
Use disposable VMs for full installation checks on each supported distribution.
