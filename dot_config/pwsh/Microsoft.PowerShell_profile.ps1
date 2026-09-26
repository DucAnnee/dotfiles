$env:PATH = "$HOME\.local\bin;$env:PATH"

$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
$env:CC = "gcc"
$env:CXX = "g++"

# UTF-8 console
chcp 65001 > $null

$utf8 = [System.Text.UTF8Encoding]::new($false)

[Console]::InputEncoding = $utf8
[Console]::OutputEncoding = $utf8
$OutputEncoding = $utf8

# alias conflict removal
@("gc", "gs", "gcm") | ForEach-Object {
    Remove-Item "Alias:$_" -Force -ErrorAction SilentlyContinue
}

function gs  { git status @args }
function ga  { git add @args }
function gc  { git commit -m @args }
function gf  { git fetch @args }
function gp { git pull --rebase @args }
function gd  { git diff @args }
function gl  { git lg @args }
function gsw { git switch @args }
function gsts { git stash @args }

# Directory navigation
function ..       { Set-Location .. }
function ...      { Set-Location ../.. }
function ....     { Set-Location ../../.. }
function .....    { Set-Location ../../../.. }
function ......   { Set-Location ../../../../.. }
function .......  { Set-Location ../../../../../.. }

Invoke-Expression (&starship init powershell)
Invoke-Expression (& { (zoxide init powershell | Out-String) })
