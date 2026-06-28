# LinkUp Studio PowerShell Profile v2.0
# Premium Developer Environment - GitHub Dark Theme

$ErrorActionPreference = "Continue"

# GitHub Colors
$GitHubColors = @{
    TextPrimary = "White"
    TextSecondary = "DarkGray"
    AccentBlue = "Cyan"
    AccentPurple = "Magenta"
    Success = "Green"
    Warning = "Yellow"
    Danger = "Red"
}

# Git Functions
function Get-GitBranch {
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0 -and $branch) { return $branch }
    } catch {}
    return $null
}

function Get-GitStatus {
    try { git status --short 2>$null } catch { return $null }
}

# Git Aliases
Set-Alias -Name gs -Value Get-GitStatus -Option AllScope
Set-Alias -Name gb -Value Get-GitBranch -Option AllScope

function gst { git status }
function gsta { git status }
function gsh { git show }
function gcl { git clone $args }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gbra { git branch -a }
function ga { git add $args }
function gaa { git add --all }
function gcm { git commit -m $args }
function gca { git commit --amend }
function gpush { git push }
function gpusht { git push --set-upstream origin $(Get-GitBranch) }
function gpull { git pull }
function gfetcha { git fetch --all }
function gfetcho { git fetch origin }
function gmerge { git merge $args }
function grebase { git rebase $args }
function greset { git reset $args }
function gresh { git reset --hard $args }
function gundo { git reset --soft HEAD~1 }
function gdiscard { git checkout -- $args }
function gstash { git stash }
function gstashl { git stash list }
function gstashpop { git stash pop }
function gl { git log --oneline -20 }
function gll { git log --oneline --graph --all -15 }
function gdiff { git diff $args }
function gdiffc { git diff --cached $args }
function gsync { git fetch origin; git pull --rebase }
function gremote { git remote -v }

# Navigation
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ~ { Set-Location $HOME }
function desk { Set-Location ([Environment]::GetFolderPath("Desktop")) }

# List
function ll { Get-ChildItem -Force -ErrorAction SilentlyContinue | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function la { Get-ChildItem -Force -ErrorAction SilentlyContinue }

# Developer
function dev {
    param([string]$Path)
    if ($Path) {
        if (Test-Path $Path) { Set-Location $Path }
        else { Write-Host "Path not found: $Path" -ForegroundColor Red; return }
    }
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  LinkUp Studio Developer Environment" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    $branch = Get-GitBranch
    if ($branch) { Write-Host "  Branch: $branch" -ForegroundColor Cyan }
    Write-Host ""
}

function sysinfo {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  System Information" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Computer: $env:COMPUTERNAME" -ForegroundColor Gray
    Write-Host "  User: $env:USERNAME" -ForegroundColor Gray
    Write-Host "  OS: $([System.Environment]::OSVersion.VersionString)" -ForegroundColor Gray
    Write-Host "  PowerShell: $($PSVersionTable.PSVersion)" -ForegroundColor Gray
    Write-Host ""
}

function oh {
    Write-Host "Opening OpenHands..." -ForegroundColor Cyan
    Start-Process "https://app.all-hands.dev"
}

function proj {
    param([string]$Name)
    $projectsPath = "$env:USERPROFILE\Projects"
    if ($Name) {
        $projectPath = Join-Path $projectsPath $Name
        if (Test-Path $projectPath) { Set-Location $projectPath; dev }
        else { Write-Host "Project not found: $Name" -ForegroundColor Red }
    }
}

# Docker
function dps { docker ps }
function dpsa { docker ps -a }
function dstop { docker stop $args }
function drm { docker rm $args }
function dlogs { docker logs $args }
function dsh { docker exec -it $args /bin/sh }
function dbuild { docker build -t $args . }
function dcupd { docker-compose up -d }
function dcdn { docker-compose down }

# npm
function ni { npm install $args }
function nr { npm run $args }
function nrd { npm run dev }
function nrb { npm run build }
function nrt { npm run test }

# Welcome
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  LINKUP STUDIO v2.0" -ForegroundColor Cyan
Write-Host "  Developer Workspace" -ForegroundColor Gray
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Commands: dev, sysinfo, oh, proj" -ForegroundColor Gray
Write-Host ""

# Prompt
function prompt {
    $branch = Get-GitBranch
    $promptStr = ""
    if ($branch) { $promptStr += "[$branch] " }
    $path = (Get-Location).Path.Replace($HOME, "~")
    if ($path.Length -gt 40) { $path = "~..." + $path.Substring($path.Length - 37) }
    $promptStr += "$path "
    if (Test-Path .git) {
        $status = Get-GitStatus
        if ($status) {
            $staged = ($status | Where-Object { $_.TrimStart().StartsWith("M") -or $_.TrimStart().StartsWith("A") }).Count
            $modified = ($status | Where-Object { $_.TrimStart().StartsWith(" M") -or $_.TrimStart().StartsWith("??") }).Count
            if ($staged -gt 0) { $promptStr += "[+$staged] " }
            if ($modified -gt 0) { $promptStr += "[~$modified] " }
        }
    }
    $promptStr += "`n> "
    if ($global:LAST_EXIT_CODE -eq 0) {
        Write-Host $promptStr -NoNewline -ForegroundColor Green
    } else {
        Write-Host $promptStr -NoNewline -ForegroundColor Red
    }
    return ""
}
