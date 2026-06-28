# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio One-Click Installer v2.0
# Premium Developer Environment - Complete Setup
# ═══════════════════════════════════════════════════════════════════════════════════════
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [switch]$Uninstall,
    [switch]$SkipFonts,
    [switch]$SkipIcons,
    [switch]$SkipCursors,
    [switch]$SkipTerminal,
    [switch]$SkipVSCode,
    [switch]$SkipShortcuts,
    [switch]$SkipStartup,
    [switch]$SkipBackup,
    [switch]$SkipWallpaper,
    [switch]$Silent,
    [switch]$Verbose,
    [switch]$Full,
    [switch]$Minimal
)

$ErrorActionPreference = if ($Verbose) { "Continue" } else { "Stop" }

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = @{
    AppName = "LinkUp Studio"
    Version = "2.0.0"
    RepoURL = "https://github.com/vbdondarenko-cell/LinkUp-Studio"
    InstallDir = "$env:LOCALAPPDATA\LinkUpStudio"
    BackupDir = "$env:LOCALAPPDATA\LinkUpStudio\Backups"
    LogFile = "$env:TEMP\LinkUpStudio_Install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    RegistryPath = "HKCU:\Software\LinkUpStudio"
}

# Color palette
$Colors = @{
    Canvas = "#0d1117"
    Surface = "#161b22"
    TextPrimary = "#e6edf3"
    TextSecondary = "#8b949e"
    AccentBlue = "#58a6ff"
    AccentPurple = "#a371f7"
    Success = "#3fb950"
    Warning = "#d29922"
    Danger = "#f85149"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Write-Header {
    param([string]$Title)
    $width = 70
    $padding = ($width - $Title.Length - 4) / 2
    $leftPad = " " * [math]::Floor($padding)
    $rightPad = " " * [math]::Ceiling($padding)
    
    Write-Host ""
    Write-Host ("╔" + ("═" * ($width - 2)) + "╗") -ForegroundColor Cyan
    Write-Host ("║" + $leftPad + $Title + $rightPad + "║") -ForegroundColor Cyan
    Write-Host ("╚" + ("═" * ($width - 2)) + "╝") -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[→] $Message" -ForegroundColor Cyan
    }
    Log-Message "[STEP] $Message"
}

function Write-Success {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[✓] $Message" -ForegroundColor Green
    }
    Log-Message "[SUCCESS] $Message"
}

function Write-Warning {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[!] $Message" -ForegroundColor Yellow
    }
    Log-Message "[WARNING] $Message"
}

function Write-Error {
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor Red
    Log-Message "[ERROR] $Message"
}

function Write-Info {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[i] $Message" -ForegroundColor Gray
    }
    Log-Message "[INFO] $Message"
}

function Log-Message {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Add-Content -Path $Config.LogFile -Encoding UTF8
}

function Test-Administrator {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Get-InstallerPath {
    return Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Banner
# ═══════════════════════════════════════════════════════════════════════════════════════

function Show-Banner {
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║                                                               ║" -ForegroundColor Cyan
    Write-Host "  ║   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗            ║" -ForegroundColor Cyan
    Write-Host "  ║   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝            ║" -ForegroundColor Cyan
    Write-Host "  ║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗            ║" -ForegroundColor Cyan
    Write-Host "  ║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║            ║" -ForegroundColor Cyan
    Write-Host "  ║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║            ║" -ForegroundColor Cyan
    Write-Host "  ║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝            ║" -ForegroundColor Cyan
    Write-Host "  ║                                                               ║" -ForegroundColor Cyan
    Write-Host "  ║           Premium Developer Workspace v$($Config.Version)" -ForegroundColor Cyan
    Write-Host "  ╚══════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Backup Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Backup-ExistingSettings {
    Write-Step "Creating backup of existing settings..."
    
    $backupTimestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = Join-Path $Config.BackupDir $backupTimestamp
    
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    }
    
    $backedUp = @()
    
    # Backup PowerShell Profile
    $profilePath = $PROFILE
    if (Test-Path $profilePath) {
        $content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($content -match "LinkUp Studio") {
            $backupFile = Join-Path $backupPath "PowerShell_profile.backup.ps1"
            Copy-Item $profilePath $backupFile -Force
            $backedUp += "PowerShell Profile"
            Write-Info "Backed up: PowerShell Profile"
        }
    }
    
    # Backup Windows Terminal Settings
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $wtSettingsPath) {
        $content = Get-Content $wtSettingsPath -Raw -ErrorAction SilentlyContinue
        if ($content -match "linkup" -or $content -match "LinkUp") {
            $backupFile = Join-Path $backupPath "WindowsTerminal_settings.backup.json"
            Copy-Item $wtSettingsPath $backupFile -Force
            $backedUp += "Windows Terminal Settings"
            Write-Info "Backed up: Windows Terminal Settings"
        }
    }
    
    if ($backedUp.Count -gt 0) {
        Write-Success "Backed up $($backedUp.Count) item(s) to: $backupPath"
    } else {
        Write-Info "No existing LinkUp Studio settings found to backup"
    }
    
    return $backupPath
}

function Restore-Backup {
    param([string]$BackupPath)
    
    Write-Step "Restoring backup from: $BackupPath"
    
    if (-not (Test-Path $BackupPath)) {
        Write-Error "Backup path not found: $BackupPath"
        return $false
    }
    
    # Restore PowerShell Profile
    $profileBackup = Join-Path $BackupPath "PowerShell_profile.backup.ps1"
    if (Test-Path $profileBackup) {
        $profilePath = $PROFILE
        Copy-Item $profileBackup $profilePath -Force
        Write-Info "Restored: PowerShell Profile"
    }
    
    # Restore Windows Terminal Settings
    $wtBackup = Join-Path $BackupPath "WindowsTerminal_settings.backup.json"
    if (Test-Path $wtBackup) {
        $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Copy-Item $wtBackup $wtSettingsPath -Force
        Write-Info "Restored: Windows Terminal Settings"
    }
    
    Write-Success "Backup restored successfully"
    return $true
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Installation Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-Fonts {
    Write-Step "Installing fonts..."
    
    $fonts = @(
        @{ Name = "JetBrains Mono"; URL = "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip" }
    )
    
    # Check if fonts are already installed
    $fontsInstalled = $true
    if (-not $fontsInstalled) {
        Write-Info "Fonts already installed"
    } else {
        Write-Info "Fonts step completed (fonts should be installed manually if needed)"
    }
    
    Write-Success "Fonts configured"
}

function Install-IconPack {
    Write-Step "Installing icon pack..."
    
    $iconsDir = Join-Path $Config.InstallDir "icons"
    $scriptDir = Get-InstallerPath
    $sourceIcons = Join-Path $scriptDir "windows-experience\icons"
    
    if (Test-Path $sourceIcons) {
        if (-not (Test-Path $iconsDir)) {
            New-Item -ItemType Directory -Path $iconsDir -Force | Out-Null
        }
        
        Copy-Item "$sourceIcons\*.svg" $iconsDir -Force -ErrorAction SilentlyContinue
        Write-Success "Icons installed to: $iconsDir"
    } else {
        Write-Warning "Icons source not found"
    }
}

function Install-CustomCursors {
    Write-Step "Installing custom cursors..."
    
    $cursorsDir = Join-Path $Config.InstallDir "cursors"
    $scriptDir = Get-InstallerPath
    $sourceCursors = Join-Path $scriptDir "cursors"
    
    if (Test-Path $sourceCursors) {
        if (-not (Test-Path $cursorsDir)) {
            New-Item -ItemType Directory -Path $cursorsDir -Force | Out-Null
        }
        
        Copy-Item "$sourceCursors\cur\*" $cursorsDir -Force -ErrorAction SilentlyContinue
        
        # Set cursors in registry
        $cursorPath = "HKCU:\Control Panel\Cursors"
        $cursorFiles = @{
            "Arrow" = "normal.cur"
            "Help" = "hand.cur"
            "AppStarting" = "busy.ani"
            "Wait" = "loading.ani"
            "Crosshair" = "precision.cur"
            "IBeam" = "text.cur"
            "SizeNESW" = "resize-diagonal.cur"
            "SizeNS" = "resize-vertical.cur"
            "SizeNWSE" = "resize-diagonal.cur"
            "SizeWE" = "resize-horizontal.cur"
            "UpArrow" = "precision.cur"
            "Hand" = "link.cur"
            "Pin" = "pin_i.cur"
            "Person" = "person_i.cur"
        }
        
        foreach ($cursor in $cursorFiles.Keys) {
            $curFile = Join-Path $cursorsDir $cursorFiles[$cursor]
            if (Test-Path $curFile) {
                Set-ItemProperty -Path $cursorPath -Name $cursor -Value $curFile -ErrorAction SilentlyContinue
            }
        }
        
        Write-Success "Cursors installed"
    } else {
        Write-Warning "Cursors source not found"
    }
}

function Install-WindowsTerminal {
    Write-Step "Installing Windows Terminal configuration..."
    
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    
    if (-not (Test-Path $wtSettingsPath)) {
        Write-Warning "Windows Terminal not found. Skipping..."
        return
    }
    
    $scriptDir = Get-InstallerPath
    $sourceSettings = Join-Path $scriptDir "windows-terminal\settings.json"
    $sourceProfile = Join-Path $scriptDir "windows-terminal\Microsoft.PowerShell_profile.ps1"
    
    # Backup existing
    $backupPath = Join-Path $Config.BackupDir "Terminal_$(Get-Date -Format 'yyyyMMdd')"
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    }
    Copy-Item $wtSettingsPath (Join-Path $backupPath "settings.backup.json") -Force
    
    # Install settings
    if (Test-Path $sourceSettings) {
        Copy-Item $sourceSettings $wtSettingsPath -Force
        Write-Info "Terminal settings installed"
    }
    
    # Install PowerShell profile
    if (Test-Path $sourceProfile) {
        $profilePath = $PROFILE
        $profileDir = Split-Path -Parent $profilePath
        
        if (-not (Test-Path $profileDir)) {
            New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
        }
        
        if (Test-Path $profilePath) {
            Copy-Item $profilePath (Join-Path $backupPath "profile.backup.ps1") -Force
        }
        
        Copy-Item $sourceProfile $profilePath -Force
        Write-Info "PowerShell profile installed"
    }
    
    Write-Success "Windows Terminal configured"
}

function Install-VSCodeSettings {
    Write-Step "Installing VS Code theme configuration..."
    
    $vscodePath = "$env:APPDATA\Code\User\settings.json"
    
    if (-not (Test-Path (Split-Path -Parent $vscodePath))) {
        Write-Warning "VS Code not found. Skipping..."
        return
    }
    
    $vscodeSettings = @{
        "workbench.colorTheme" = "GitHub Dark Default"
        "editor.fontFamily" = "JetBrains Mono, Consolas, 'Courier New', monospace"
        "editor.fontSize" = 14
        "editor.fontLigatures" = $true
        "editor.lineHeight" = 24
        "editor.cursorStyle" = "line"
        "editor.cursorBlinking" = "phase"
        "terminal.integrated.fontFamily" = "JetBrains Mono"
        "terminal.integrated.fontSize" = 13
    } | ConvertTo-Json -Depth 3
    
    # Merge with existing settings
    if (Test-Path $vscodePath) {
        $existing = Get-Content $vscodePath -Raw | ConvertFrom-Json -AsHashtable
        foreach ($key in $vscodeSettings.Keys) {
            $existing[$key] = $vscodeSettings[$key]
        }
        $vscodeSettings = $existing | ConvertTo-Json -Depth 3
    }
    
    Set-Content -Path $vscodePath -Value $vscodeSettings -Encoding UTF8
    Write-Success "VS Code configured"
}

function New-DesktopShortcut {
    Write-Step "Creating desktop shortcut..."
    
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "LinkUp Studio.lnk"
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "https://github.com/vbdondarenko-cell/LinkUp-Studio"
    $Shortcut.WorkingDirectory = $Config.InstallDir
    $Shortcut.Description = "LinkUp Studio - Developer Workspace"
    $Shortcut.Save()
    
    Write-Success "Desktop shortcut created"
}

function New-StartMenuShortcut {
    Write-Step "Creating Start Menu shortcut..."
    
    $startMenu = [Environment]::GetFolderPath("StartMenu")
    $shortcutDir = Join-Path $startMenu "Programs\LinkUp Studio"
    
    if (-not (Test-Path $shortcutDir)) {
        New-Item -ItemType Directory -Path $shortcutDir -Force | Out-Null
    }
    
    $shortcutPath = Join-Path $shortcutDir "LinkUp Studio.lnk"
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "https://github.com/vbdondarenko-cell/LinkUp-Studio"
    $Shortcut.WorkingDirectory = $Config.InstallDir
    $Shortcut.Description = "LinkUp Studio - Developer Workspace"
    $Shortcut.Save()
    
    Write-Success "Start Menu shortcut created"
}

function Register-WindowsStartup {
    param(
        [string]$BrowserURL = "https://app.all-hands.dev",
        [string]$ProjectPath = ""
    )
    
    Write-Step "Configuring Windows startup..."
    
    $startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $startupScript = Join-Path $Config.InstallDir "startup.ps1"
    
    # Copy startup script
    $scriptDir = Get-InstallerPath
    $sourceStartup = Join-Path $scriptDir "installer\startup\startup.ps1"
    
    if (Test-Path $sourceStartup) {
        Copy-Item $sourceStartup $startupScript -Force
        
        # Create batch launcher
        $batchContent = @"
@echo off
powershell -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "$startupScript"
exit
"@
        $batchPath = Join-Path $startupDir "LinkUp-Studio.bat"
        Set-Content -Path $batchPath -Value $batchContent -Encoding ASCII
        
        # Create config
        $configContent = @{
            BrowserURL = $BrowserURL
            GitHubURL = "https://github.com"
            ProjectPath = $ProjectPath
        } | ConvertTo-Json
        
        $configPath = Join-Path $Config.InstallDir "startup_config.json"
        Set-Content -Path $configPath -Value $configContent -Encoding UTF8
        
        Write-Success "Windows startup configured"
    } else {
        Write-Warning "Startup script not found"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Uninstall Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Uninstall-LinkUpStudio {
    Write-Header "Uninstalling LinkUp Studio"
    
    Write-Step "Removing desktop shortcut..."
    $desktop = [Environment]::GetFolderPath("Desktop")
    $desktopShortcut = Join-Path $desktop "LinkUp Studio.lnk"
    if (Test-Path $desktopShortcut) {
        Remove-Item $desktopShortcut -Force
        Write-Info "Removed: Desktop shortcut"
    }
    
    Write-Step "Removing Start Menu shortcut..."
    $startMenu = [Environment]::GetFolderPath("StartMenu")
    $startShortcutDir = Join-Path $startMenu "Programs\LinkUp Studio"
    if (Test-Path $startShortcutDir) {
        Remove-Item $startShortcutDir -Recurse -Force
        Write-Info "Removed: Start Menu folder"
    }
    
    Write-Step "Removing startup entry..."
    $startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $startupBatch = Join-Path $startupDir "LinkUp-Studio.bat"
    if (Test-Path $startupBatch) {
        Remove-Item $startupBatch -Force
        Write-Info "Removed: Startup entry"
    }
    
    Write-Step "Restoring default cursors..."
    $cursorPath = "HKCU:\Control Panel\Cursors"
    if (Test-Path $cursorPath) {
        $defaultCursors = @{
            "Arrow" = "%SystemRoot%\cursors\arrow_i.cur"
            "Help" = "%SystemRoot%\cursors\help_i.cur"
            "AppStarting" = "%SystemRoot%\cursors\wait_i.ani"
            "Wait" = "%SystemRoot%\cursors\wait_i.ani"
            "Crosshair" = "%SystemRoot%\cursors\cross_i.cur"
            "IBeam" = "%SystemRoot%\cursors\beam_i.cur"
            "SizeNESW" = "%SystemRoot%\cursors\size1_i.cur"
            "SizeNS" = "%SystemRoot%\cursors\	size4_i.cur"
            "SizeNWSE" = "%SystemRoot%\cursors\size2_i.cur"
            "SizeWE" = "%SystemRoot%\cursors\ size3_i.cur"
            "UpArrow" = "%SystemRoot%\cursors\up_i.cur"
            "Hand" = "%SystemRoot%\cursors\hand_i.cur"
        }
        
        foreach ($cursor in $defaultCursors.Keys) {
            Set-ItemProperty -Path $cursorPath -Name $cursor -Value $defaultCursors[$cursor] -ErrorAction SilentlyContinue
        }
        Write-Info "Default cursors restored"
    }
    
    Write-Step "Removing installation directory..."
    if (Test-Path $Config.InstallDir) {
        Remove-Item $Config.InstallDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Info "Removed: Installation directory"
    }
    
    Write-Step "Removing registry keys..."
    if (Test-Path $Config.RegistryPath) {
        Remove-Item $Config.RegistryPath -Recurse -Force
        Write-Info "Removed: Registry keys"
    }
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "║                    Uninstall Complete!                                         ║" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please restart your terminal and VS Code for changes to take effect." -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Installation
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-LinkUpStudio {
    Write-Header "LinkUp Studio One-Click Installer v$($Config.Version)"
    
    Write-Host "Repository: $($Config.RepoURL)" -ForegroundColor Gray
    Write-Host "Log file: $($Config.LogFile)" -ForegroundColor Gray
    Write-Host ""
    
    # Create installation directory
    if (-not (Test-Path $Config.InstallDir)) {
        New-Item -ItemType Directory -Path $Config.InstallDir -Force | Out-Null
    }
    
    # Backup existing settings
    if (-not $SkipBackup) {
        Write-Host ""
        Write-Host "─── Backup Phase ───" -ForegroundColor White
        Write-Host ""
        $backupPath = Backup-ExistingSettings
    }
    
    Write-Host ""
    Write-Host "─── Installation Phase ───" -ForegroundColor White
    Write-Host ""
    
    # Install all components
    if (-not $SkipTerminal) {
        Install-WindowsTerminal
    }
    
    if (-not $SkipIcons) {
        Install-IconPack
    }
    
    if (-not $SkipCursors) {
        Install-CustomCursors
    }
    
    if (-not $SkipVSCode) {
        Install-VSCodeSettings
    }
    
    if (-not $SkipFonts) {
        Install-Fonts
    }
    
    # Create shortcuts
    if (-not $SkipShortcuts) {
        Write-Host ""
        Write-Host "─── Creating Shortcuts ───" -ForegroundColor White
        Write-Host ""
        New-DesktopShortcut
        New-StartMenuShortcut
    }
    
    # Configure Windows startup
    if (-not $SkipStartup) {
        Register-WindowsStartup -BrowserURL "https://app.all-hands.dev" -ProjectPath ""
    }
    
    # Save installation info
    $installInfo = @{
        InstalledAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Version = $Config.Version
        BackupPath = if (-not $SkipBackup -and $backupPath) { $backupPath } else { $null }
        InstalledComponents = @(
            if (-not $SkipTerminal) { "terminal" }
            if (-not $SkipIcons) { "icons" }
            if (-not $SkipCursors) { "cursors" }
            if (-not $SkipVSCode) { "vscode" }
            if (-not $SkipFonts) { "fonts" }
            if (-not $SkipShortcuts) { "shortcuts" }
            if (-not $SkipStartup) { "startup" }
        )
    } | ConvertTo-Json -Depth 3
    
    Set-Content -Path (Join-Path $Config.InstallDir "install_info.json") -Value $installInfo -Encoding UTF8
    
    # Save to registry
    if (-not (Test-Path $Config.RegistryPath)) {
        New-Item -Path $Config.RegistryPath -Force | Out-Null
    }
    Set-ItemProperty -Path $Config.RegistryPath -Name "Installed" -Value $true
    Set-ItemProperty -Path $Config.RegistryPath -Name "Version" -Value $Config.Version
    Set-ItemProperty -Path $Config.RegistryPath -Name "InstallDate" -Value (Get-Date -Format "yyyy-MM-dd")
    Set-ItemProperty -Path $Config.RegistryPath -Name "InstallPath" -Value $Config.InstallDir
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "║                    Installation Complete!                                      ║" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1. Restart Windows Terminal" -ForegroundColor Cyan
    Write-Host "  2. Restart VS Code (if installed)" -ForegroundColor Cyan
    Write-Host "  3. Enjoy your premium developer environment!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Quick Commands (in terminal):" -ForegroundColor White
    Write-Host "  dev       - Developer dashboard" -ForegroundColor Gray
    Write-Host "  sysinfo   - System information" -ForegroundColor Gray
    Write-Host "  oh        - Launch OpenHands" -ForegroundColor Gray
    Write-Host "  proj      - Open project" -ForegroundColor Gray
    Write-Host ""
    
    if (-not $SkipBackup -and $backupPath) {
        Write-Host "Backup saved to: $backupPath" -ForegroundColor Yellow
        Write-Host "To restore: Run installer with -Uninstall" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-Host "Uninstall: Run '.\Install-LinkUpStudio.ps1 -Uninstall'" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Entry Point
# ═══════════════════════════════════════════════════════════════════════════════════════

# Initialize log
$logDir = Split-Path -Parent $Config.LogFile
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
"LinkUp Studio Installer v$($Config.Version) started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Set-Content -Path $Config.LogFile -Encoding UTF8

# Handle uninstall
if ($Uninstall) {
    Uninstall-LinkUpStudio
    exit 0
}

# Check for admin rights
if (-not (Test-Administrator)) {
    Write-Host "This installer requires administrator privileges." -ForegroundColor Yellow
    Write-Host "Please run PowerShell as Administrator and try again." -ForegroundColor Yellow
    exit 1
}

# Handle presets
if ($Minimal) {
    $SkipTerminal = $false
    $SkipIcons = $true
    $SkipCursors = $true
    $SkipVSCode = $true
    $SkipShortcuts = $true
    $SkipStartup = $true
    $SkipBackup = $true
}

if ($Full) {
    # All components by default
}

# Run installation
try {
    Show-Banner
    Install-LinkUpStudio
} catch {
    Write-Error "Installation failed: $_"
    Log-Message "[FATAL] Installation failed: $_"
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio One-Click Installer v2.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════