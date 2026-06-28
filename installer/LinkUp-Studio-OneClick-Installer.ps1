# LinkUp Studio One-Click Installer v2.0
# Premium Developer Environment - Complete Setup

param(
    [switch]$Uninstall,
    [switch]$SkipTerminal,
    [switch]$SkipIcons,
    [switch]$SkipVSCode,
    [switch]$SkipShortcuts,
    [switch]$SkipStartup,
    [switch]$Minimal
)

$ErrorActionPreference = "Stop"

# Get script directory (works when run with -File parameter)
$ScriptDir = if ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $PSScriptRoot
}

# Go up two levels from installer folder to get repo root
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

$Config = @{
    AppName = "LinkUp Studio"
    Version = "2.0.0"
    InstallDir = "$env:LOCALAPPDATA\LinkUpStudio"
}

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "[>>>] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[!!] $Message" -ForegroundColor Yellow
}

function Test-Administrator {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Install-WindowsTerminal {
    Write-Step "Installing Windows Terminal..."
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (-not (Test-Path $wtSettingsPath)) {
        Write-Warning "Windows Terminal not found"
        return
    }
    $sourceSettings = Join-Path $RepoRoot "windows-terminal\settings.json"
    $sourceProfile = Join-Path $RepoRoot "windows-terminal\Microsoft.PowerShell_profile.ps1"
    if (Test-Path $sourceSettings) {
        Copy-Item $sourceSettings $wtSettingsPath -Force
        Write-Success "Terminal settings installed"
    }
    if (Test-Path $sourceProfile) {
        $profilePath = $PROFILE
        $profileDir = Split-Path -Parent $profilePath
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        Copy-Item $sourceProfile $profilePath -Force
        Write-Success "PowerShell profile installed"
    }
}

function Install-IconPack {
    Write-Step "Installing icons..."
    $iconsDir = Join-Path $Config.InstallDir "icons"
    $sourceIcons = Join-Path $RepoRoot "windows-experience\icons"
    if (Test-Path $sourceIcons) {
        if (-not (Test-Path $iconsDir)) {
            New-Item -ItemType Directory -Path $iconsDir -Force | Out-Null
        }
        Copy-Item "$sourceIcons\*.svg" $iconsDir -Force -ErrorAction SilentlyContinue
        Write-Success "Icons installed"
    }
}

function Install-VSCodeSettings {
    Write-Step "Installing VS Code theme..."
    $vscodePath = "$env:APPDATA\Code\User\settings.json"
    if (-not (Test-Path (Split-Path -Parent $vscodePath))) {
        Write-Warning "VS Code not found"
        return
    }
    $settings = @{
        "workbench.colorTheme" = "GitHub Dark Default"
        "editor.fontFamily" = "JetBrains Mono, Consolas, monospace"
        "editor.fontSize" = 14
        "terminal.integrated.fontFamily" = "JetBrains Mono"
    } | ConvertTo-Json
    Set-Content -Path $vscodePath -Value $settings -Encoding UTF8
    Write-Success "VS Code configured"
}

function New-DesktopShortcut {
    Write-Step "Creating shortcut..."
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "LinkUp Studio.lnk"
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "https://github.com/vbdondarenko-cell/LinkUp-Studio"
    $Shortcut.WorkingDirectory = $Config.InstallDir
    $Shortcut.Description = "LinkUp Studio - Developer Workspace"
    $Shortcut.Save()
    Write-Success "Shortcut created"
}

function Register-WindowsStartup {
    Write-Step "Configuring startup..."
    $startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $startupScript = Join-Path $Config.InstallDir "startup.ps1"
    $sourceStartup = Join-Path $RepoRoot "installer\startup\startup.ps1"
    if (Test-Path $sourceStartup) {
        Copy-Item $sourceStartup $startupScript -Force
        $batchContent = "@echo off`npowershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$startupScript`"`nexit"
        $batchPath = Join-Path $startupDir "LinkUp-Studio.bat"
        Set-Content -Path $batchPath -Value $batchContent -Encoding ASCII
        Write-Success "Startup configured"
    }
}

function Uninstall-LinkUpStudio {
    Write-Header "Uninstalling LinkUp Studio"
    $desktop = [Environment]::GetFolderPath("Desktop")
    Remove-Item (Join-Path $desktop "LinkUp Studio.lnk") -Force -ErrorAction SilentlyContinue
    $startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    Remove-Item (Join-Path $startupDir "LinkUp-Studio.bat") -Force -ErrorAction SilentlyContinue
    if (Test-Path $Config.InstallDir) {
        Remove-Item $Config.InstallDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Success "Uninstall complete"
}

# Main
if ($Uninstall) {
    Uninstall-LinkUpStudio
    exit 0
}

if (-not (Test-Administrator)) {
    Write-Host "Please run as Administrator!" -ForegroundColor Yellow
    exit 1
}

Write-Header "LinkUp Studio Installer v2.0"

if (-not (Test-Path $Config.InstallDir)) {
    New-Item -ItemType Directory -Path $Config.InstallDir -Force | Out-Null
}

if (-not $SkipTerminal) { Install-WindowsTerminal }
if (-not $SkipIcons) { Install-IconPack }
if (-not $SkipVSCode) { Install-VSCodeSettings }
if (-not $SkipShortcuts) { New-DesktopShortcut }
if (-not $SkipStartup) { Register-WindowsStartup }

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Restart Windows Terminal to apply changes" -ForegroundColor Cyan
Write-Host ""
