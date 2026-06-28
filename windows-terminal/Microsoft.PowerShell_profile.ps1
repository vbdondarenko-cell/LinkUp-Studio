# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio PowerShell Profile v2.0
# Premium Developer Environment - GitHub Dark Theme
# ═══════════════════════════════════════════════════════════════════════════════════════

# ─────────────────────────────────────────────────────────────────────────────────────
# Error Handling
# ─────────────────────────────────────────────────────────────────────────────────────
$ErrorActionPreference = "Continue"
$global:LAST_EXIT_CODE = 0

# ─────────────────────────────────────────────────────────────────────────────────────
# Environment Setup
# ─────────────────────────────────────────────────────────────────────────────────────

# Terminal title
$host.UI.RawUI.WindowTitle = "LinkUp Studio Terminal"

# ─────────────────────────────────────────────────────────────────────────────────────
# Colors (GitHub Dark)
# ─────────────────────────────────────────────────────────────────────────────────────
$GitHubColors = @{
    Canvas = "#0d1117"
    Surface = "#161b22"
    Elevated = "#21262d"
    Border = "#30363d"
    TextPrimary = "#e6edf3"
    TextSecondary = "#8b949e"
    TextTertiary = "#6e7681"
    AccentBlue = "#58a6ff"
    AccentPurple = "#a371f7"
    Success = "#3fb950"
    Warning = "#d29922"
    Danger = "#f85149"
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────────────

function Get-GitBranch {
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -eq 0 -and $branch) {
            return $branch
        }
    } catch {}
    return $null
}

function Get-GitStatus {
    try {
        git status --short 2>$null
    } catch {
        return $null
    }
}

function Test-InGitRepo {
    try {
        git rev-parse --is-inside-work-tree 2>$null | Out-Null
        return $?
    } catch {
        return $false
    }
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Git Configuration
# ─────────────────────────────────────────────────────────────────────────────────────
Set-Alias -Name gs -Value Get-GitStatus -Option AllScope
Set-Alias -Name gb -Value Get-GitBranch -Option AllScope
Set-Alias -Name ginit -Value Initialize-GitRepo -Option AllScope

# Git aliases
function gst { git status }
function gsta { git status }
function gstu { git status -u }
function gsh { git show }
function gcl { git clone $args }
function gco { git checkout $args }
function gcb { git checkout -b $args }
function gbra { git branch -a }
function gbrd { git branch -d $args }
function gbrD { git branch -D $args }
function ga { git add $args }
function gaa { git add --all }
function gcm { git commit -m $args }
function gca { git commit --amend }
function gcf { git commit --fixup $args }
function gsquash { git rebase -i HEAD~$args }
function gpush { git push }
function gpusht { git push --set-upstream origin $(Get-GitBranch) }
function gpull { git pull }
function gpullr { git pull --rebase }
function gfetcha { git fetch --all }
function gfetcho { git fetch origin }
function gmerge { git merge $args }
function grebase { git rebase $args }
function gcont { git rebase --continue }
function gabort { git rebase --abort }
function greset { git reset $args }
function gresh { git reset --hard $args }
function gsoft { git reset --soft $args }
function gundo { git reset --soft HEAD~1 }
function gdiscard { git checkout -- $args }
function gclean { git clean -fd }
function gstash { git stash }
function gstashp { git stash -p }
function gstashl { git stash list }
function gstashs { git stash save $args }
function gstashpop { git stash pop }
function gstashd { git stash drop }
function gl { git log --oneline -20 }
function gll { git log --oneline --graph --all -15 }
function gdiff { git diff $args }
function gdiffc { git diff --cached $args }
function gdiffstaged { git diff --staged }
function gblame { git blame $args }
function gtag { git tag $args }
function gtags { git tag -l }
function gpushtag { git push origin --tags }
function gremote { git remote -v }
function gremoveadd { git remote add $args }
function gremoverm { git remote remove $args }
function gsync { git fetch origin && git pull --rebase }

function Initialize-GitRepo {
    param([string]$RemoteUrl)
    git init
    if ($RemoteUrl) { git remote add origin $RemoteUrl }
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Navigation Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }
function ~ { Set-Location $HOME }
function desk { Set-Location ([Environment]::GetFolderPath("Desktop")) }
function docs { Set-Location ([Environment]::GetFolderPath("MyDocuments")) }
function down { Set-Location ([Environment]::GetFolderPath("UserProfile") + "\Downloads") }

# ─────────────────────────────────────────────────────────────────────────────────────
# List Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
function ll { Get-ChildItem -Force -ErrorAction SilentlyContinue | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function la { Get-ChildItem -Force -ErrorAction SilentlyContinue }
function lla { Get-ChildItem -Force -ErrorAction SilentlyContinue | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function lt { Get-ChildItem -Force -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } }
function lf { Get-ChildItem -Force -ErrorAction SilentlyContinue | Where-Object { -not $_.PSIsContainer } }
function ls { Get-ChildItem -ErrorAction SilentlyContinue }
function find { Get-ChildItem -Recurse -Filter "*$args*" -ErrorAction SilentlyContinue }

# ─────────────────────────────────────────────────────────────────────────────────────
# Developer Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
Set-Alias -Name which -Value Get-CommandPath -Option AllScope
Set-Alias -Name reload -Value Reload-PowerShell -Option AllScope

function Get-CommandPath {
    param([string]$Name)
    $cmd = Get-Command -Name $Name -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host $cmd.Source -ForegroundColor Cyan
        $cmd | Select-Object Name, Version, Source | Format-Table -AutoSize
    }
}

function Reload-PowerShell {
    Write-Host "Reloading PowerShell..." -ForegroundColor Yellow
    & $PSCommandPath
    exit
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Node.js / npm Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
function ni { npm install $args }
function nis { npm install $args --save }
function nisd { npm install $args --save-dev }
function nig { npm install -g $args }
function nu { npm uninstall $args }
function nrs { npm uninstall --save $args }
function nr { npm run $args }
function nrt { npm run test }
function nrw { npm run watch }
function nrb { npm run build }
function nrd { npm run dev }
function nrp { npm run prod }
function nrl { npm run lint }
function nrf { npm run lint:fix }
function nrc { npm run coverage }
function nio { npm info $args }
function nls { npm list }
function nlsg { npm list --global }
function nup { npm update }
function npr { npm prune }
function nvc { npx vite $args }
function nnext { npx next $args }
function nreact { npx create-react-app $args }

# ─────────────────────────────────────────────────────────────────────────────────────
# Python Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
function pa { python $args }
function pa3 { python3 $args }
function pipi { pip install $args }
function pip3i { pip3 install $args }
function pipu { pip uninstall $args }
function pipl { pip list }
function pipf { pip freeze }
function pipreq { pip freeze > requirements.txt }
function pshell { python -m venv venv; .\venv\Scripts\Activate.ps1 }
function pact { python activate $args }
function jupyter { jupyter notebook $args }

# ─────────────────────────────────────────────────────────────────────────────────────
# Docker Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
function dps { docker ps }
function dpsa { docker ps -a }
function dips { docker images }
function dstart { docker start $args }
function dstop { docker stop $args }
function drm { docker rm $args }
function drmi { docker rmi $args }
function drmf { docker rm -f $args }
function dexec { docker exec -it $args }
function dlogs { docker logs $args }
function dlogsf { docker logs -f $args }
function dsh { docker exec -it $args /bin/sh }
function dbuild { docker build -t $args . }
function drun { docker run -it $args }
function dkill { docker kill $args }
function dprune { docker system prune -f }
function dnet { docker network ls }
function dvol { docker volume ls }
function dcompose { docker-compose $args }
function dcup { docker-compose up $args }
function dcupd { docker-compose up -d }
function dcdn { docker-compose down }
function dcbuild { docker-compose build }
function dcrestart { docker-compose restart }
function dclogs { docker-compose logs -f }

# Kubernetes shortcuts
function kga { kubectl get all }
function kgp { kubectl get pods }
function kgs { kubectl get services }
function kgd { kubectl get deployments }
function kgn { kubectl get nodes }
function kdp { kubectl describe pod $args }
function kds { kubectl describe service $args }
function klogs { kubectl logs $args }
function klogsf { kubectl logs -f $args }
function kex { kubectl exec -it $args }
function kapply { kubectl apply -f $args }
function kdelete { kubectl delete -f $args }

# ─────────────────────────────────────────────────────────────────────────────────────
# GitHub CLI Shortcuts
# ─────────────────────────────────────────────────────────────────────────────────────
function ghcl { gh repo clone $args }
function ghos { gh repo view --web }
function ghcr { gh repo create $args }
function ghp { gh pr $args }
function ghpc { gh pr create }
function ghpl { gh pr list }
function ghpo { gh pr checkout $args }
function ghi { gh issue $args }
function ghic { gh issue create }
function ghst { gh status }

# ─────────────────────────────────────────────────────────────────────────────────────
# OpenHands Integration
# ─────────────────────────────────────────────────────────────────────────────────────
function oh {
    param([string]$Task, [switch]$Interactive)
    $ohPath = Get-OpenHandsPath
    if ($ohPath) {
        Write-Host "Launching OpenHands..." -ForegroundColor Cyan
        Start-Process -FilePath $ohPath
    } else {
        Write-Host "OpenHands CLI not found. Opening web version..." -ForegroundColor Yellow
        Start-Process "https://app.all-hands.dev"
    }
}

function Get-OpenHandsPath {
    $paths = @(
        "$env:LOCALAPPDATA\Programs\open-hands\openhands.exe",
        "$env:LOCALAPPDATA\open-hands\openhands.exe",
        "$env:ProgramFiles\OpenHands\openhands.exe"
    )
    foreach ($path in $paths) {
        if (Test-Path $path) { return $path }
    }
    return $null
}

# ─────────────────────────────────────────────────────────────────────────────────────
# System Functions
# ─────────────────────────────────────────────────────────────────────────────────────
function sysinfo {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║               LinkUp Studio System Information               ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host ""
    Write-Host "  Computer Name: " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    Write-Host $env:COMPUTERNAME
    Write-Host "  User Name:      " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    Write-Host $env:USERNAME
    Write-Host "  OS:             " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    Write-Host (Get-CimInstance Win32_OperatingSystem).Caption
    Write-Host "  PowerShell:     " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    Write-Host $PSVersionTable.PSVersion
    Write-Host "  Date:           " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    Write-Host (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Write-Host ""
}

function portcheck {
    param([int]$Port)
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-Host "Port $Port is LISTENING" -ForegroundColor $GitHubColors.Success
    } else {
        Write-Host "Port $Port is NOT available" -ForegroundColor $GitHubColors.Danger
    }
}

function killport {
    param([int]$Port)
    $pid = (Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue).OwningProcess
    if ($pid) {
        Stop-Process -Id $pid -Force
        Write-Host "Killed process on port $Port" -ForegroundColor $GitHubColors.Success
    }
}

function ipinfo {
    Write-Host "Internal IP: " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    (Get-NetIPAddress -InterfaceAlias Wi-Fi -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress
    Write-Host "External IP: " -NoNewline -ForegroundColor $GitHubColors.TextSecondary
    try { (Invoke-WebRequest -Uri "https://api.ipify.org" -UseBasicParsing).Content } catch {}
}

function flushdns {
    Clear-DnsClientCache
    Write-Host "DNS cache cleared" -ForegroundColor $GitHubColors.Success
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Development Environment
# ─────────────────────────────────────────────────────────────────────────────────────
function dev {
    param([string]$Path)
    if ($Path) {
        if (Test-Path $Path) { Set-Location $Path } else {
            Write-Host "Path not found: $Path" -ForegroundColor $GitHubColors.Danger
            return
        }
    }
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║              LinkUp Studio Developer Environment              ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host ""
    $branch = Get-GitBranch
    if ($branch) {
        Write-Host "   $branch" -ForegroundColor $GitHubColors.AccentBlue
        $status = Get-GitStatus
        if ($status) {
            $staged = ($status | Where-Object { $_.TrimStart().StartsWith("M") -or $_.TrimStart().StartsWith("A") }).Count
            $modified = ($status | Where-Object { $_.TrimStart().StartsWith(" M") -or $_.TrimStart().StartsWith("??") }).Count
            Write-Host "    " -NoNewline
            if ($staged -gt 0) { Write-Host "+$staged " -ForegroundColor $GitHubColors.Success -NoNewline }
            if ($modified -gt 0) { Write-Host "[$modified]" -ForegroundColor $GitHubColors.Warning -NoNewline }
            Write-Host ""
        }
    } else {
        Write-Host "  (Not a Git repository)" -ForegroundColor $GitHubColors.TextTertiary
    }
    Write-Host ""
}

function proj {
    param([string]$Name)
    $projectsPath = "$env:USERPROFILE\Projects"
    if ($Name) {
        $projectPath = Join-Path $projectsPath $Name
        if (Test-Path $projectPath) {
            Set-Location $projectPath
            dev
        } else {
            Write-Host "Project not found: $Name" -ForegroundColor $GitHubColors.Danger
        }
    } else {
        if (Test-Path $projectsPath) {
            Write-Host "Available projects:" -ForegroundColor $GitHubColors.TextSecondary
            Get-ChildItem $projectsPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
                Write-Host "  • $($_.Name)" -ForegroundColor $GitHubColors.TextTertiary
            }
        }
    }
}

# ─────────────────────────────────────────────────────────────────────────────────────
# File Operations
# ─────────────────────────────────────────────────────────────────────────────────────
function mkcd {
    param([string]$Name)
    New-Item -ItemType Directory -Name $Name -Force | Out-Null
    Set-Location $Name
}

function touch {
    param([string]$Name)
    New-Item -ItemType File -Name $Name -Force | Out-Null
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Utility Functions
# ─────────────────────────────────────────────────────────────────────────────────────
function psgrep {
    param([string]$Name)
    Get-Process | Where-Object { $_.ProcessName -like "*$Name*" } | Format-Table Id, ProcessName, CPU, WorkingSet -AutoSize
}

function killname {
    param([string]$Name)
    Get-Process -Name $Name -ErrorAction SilentlyContinue | Stop-Process -Force
}

function http-server {
    param([int]$Port = 3000)
    python -m http.server $Port
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Oh My Posh (if available)
# ─────────────────────────────────────────────────────────────────────────────────────
try {
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        # oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\linkup.omp.json" | Invoke-Expression
    }
} catch {}

# ─────────────────────────────────────────────────────────────────────────────────────
# Terminal Icons (if available)
# ─────────────────────────────────────────────────────────────────────────────────────
try { Import-Module Terminal-Icons -ErrorAction SilentlyContinue } catch {}

# ─────────────────────────────────────────────────────────────────────────────────────
# Welcome Message
# ─────────────────────────────────────────────────────────────────────────────────────
function Show-LinkUpStudioWelcome {
    $branch = Get-GitBranch
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║                                                               ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗            ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝            ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗            ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║            ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║            ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝            ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║                                                               ║" -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  ║           Premium Developer Workspace v1.0.0                  ║" -ForegroundColor $GitHubColors.TextSecondary
    Write-Host "  ╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor $GitHubColors.AccentBlue
    if ($branch) { Write-Host ""; Write-Host "   $branch" -ForegroundColor $GitHubColors.AccentPurple }
    Write-Host ""
    Write-Host "  Quick Commands:" -ForegroundColor $GitHubColors.TextSecondary
    Write-Host "  ──────────────" -ForegroundColor $GitHubColors.Border
    Write-Host "  dev           " -NoNewline -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  →  Developer dashboard" -ForegroundColor $GitHubColors.TextTertiary
    Write-Host "  sysinfo       " -NoNewline -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  →  System information" -ForegroundColor $GitHubColors.TextTertiary
    Write-Host "  oh            " -NoNewline -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  →  Launch OpenHands" -ForegroundColor $GitHubColors.TextTertiary
    Write-Host "  proj <name>   " -NoNewline -ForegroundColor $GitHubColors.AccentBlue
    Write-Host "  →  Open project" -ForegroundColor $GitHubColors.TextTertiary
    Write-Host ""
}

Show-LinkUpStudioWelcome

# ─────────────────────────────────────────────────────────────────────────────────────
# Custom Prompt
# ─────────────────────────────────────────────────────────────────────────────────────
function prompt {
    $branch = Get-GitBranch
    $promptStr = ""
    if ($branch) { $promptStr += "   $branch " -ForegroundColor $GitHubColors.AccentPurple }
    $path = (Get-Location).Path.Replace($HOME, "~")
    if ($path.Length -gt 40) { $path = "~..." + $path.Substring($path.Length - 37) }
    $promptStr += "$path " -ForegroundColor $GitHubColors.TextPrimary
    if (Test-InGitRepo) {
        $status = Get-GitStatus
        if ($status) {
            $staged = ($status | Where-Object { $_.TrimStart().StartsWith("M") -or $_.TrimStart().StartsWith("A") }).Count
            $modified = ($status | Where-Object { $_.TrimStart().StartsWith(" M") -or $_.TrimStart().StartsWith("??") }).Count
            if ($staged -gt 0) { $promptStr += "[+$staged]" -ForegroundColor $GitHubColors.Success }
            if ($modified -gt 0) { $promptStr += "[~$modified]" -ForegroundColor $GitHubColors.Warning }
        }
    }
    $promptStr += "`n"
    if ($global:LAST_EXIT_CODE -eq 0) { $promptStr += "❯ " -ForegroundColor $GitHubColors.Success }
    else { $promptStr += "❯ " -ForegroundColor $GitHubColors.Danger }
    return $promptStr
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio PowerShell Profile v2.0 Loaded Successfully
# ═══════════════════════════════════════════════════════════════════════════════════════