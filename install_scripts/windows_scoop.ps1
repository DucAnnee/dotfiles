# Install Scoop (no admin needed)
Set-ExecutionPolicy Bypass -Scope Process -Force
iwr -useb get.scoop.sh | iex

# Add useful buckets
scoop bucket add extras
scoop bucket add nerd-fonts
scoop update

# Install packages
$pkgs = @(
    "git",
    "versions/python310",
    "mingw",
    "neovim",
    "nodejs",
    "starship",
    "wezterm",
    "zoxide",
    "miniconda3",
    "CascadiaCode-NF",
    "pwsh"
)

scoop install $pkgs

# Set config path
$xdgConfig = "$env:USERPROFILE\Documents\GitHub\dotfiles"
$condaRoot = "C:\tools\miniconda3"
$condaScripts = "$condaRoot\Scripts"
$condaCondabin = "$condaRoot\condabin"
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $xdgConfig, "User")
[Environment]::SetEnvironmentVariable("STARSHIP_CONFIG", "$xdgConfig\starship\starship.toml", "User")
[Environment]::SetEnvironmentVariable("GIT_CONFIG_GLOBAL", "$xdgConfig\git\.gitconfig", "User")
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if (-not $currentPath.Contains($condaScripts)) {
    $currentPath += ";$condaScripts"
}
if (-not $currentPath.Contains($condaCondabin)) {
    $currentPath += ";$condaCondabin"
}
[Environment]::SetEnvironmentVariable("PATH", $currentPath, "User")

$profilePath = "$env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1"

$profileDir = Split-Path $profilePath
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force
}

if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force
}

# Init Starship, zoxide, and lazy-load Conda
Add-Content $profilePath @"
# Init Starship
Invoke-Expression (&starship init powershell)

# Init zoxide
Invoke-Expression (& { (zoxide init powershell) -join "`n" })

# Lazy load Conda
function conda {
    Remove-Item function:conda -Force
    if (Test-Path "$condaScripts\conda.exe") {
        (& "$condaScripts\conda.exe" "shell.powershell" "hook") |
            Out-String | Where-Object {$_} | Invoke-Expression
    }
    conda @args
}

function ca {
    conda activate @args
}
"@

Write-Host "`n✅ Scoop environment setup complete with lazy-loaded Conda. Please restart PowerShell."
