# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Windows Experience Installer
# Premium Developer Desktop Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [switch]$ThemeOnly,
    [switch]$IconsOnly,
    [switch]$ShortcutsOnly,
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = @{
    AppName = "LinkUp Studio Experience"
    Version = "1.0.0"
    SourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    InstallDir = "$env:LOCALAPPDATA\LinkUpStudio\WindowsExperience"
    BackupDir = "$env:LOCALAPPDATA\LinkUpStudio\Backups"
    ThemeName = "GitHubDark"
    LogFile = "$env:TEMP\LinkUpStudio_Experience_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
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
    if (-not $Silent) { Write-Host "[→] $Message" -ForegroundColor Cyan }
}

function Write-Success {
    param([string]$Message)
    if (-not $Silent) { Write-Host "[✓] $Message" -ForegroundColor Green }
}

function Write-Warning {
    param([string]$Message)
    if (-not $Silent) { Write-Host "[!] $Message" -ForegroundColor Yellow }
}

function Write-Info {
    param([string]$Message)
    if (-not $Silent) { Write-Host "[i] $Message" -ForegroundColor Gray }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Backup Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Backup-CurrentSettings {
    Write-Step "Backing up current Windows settings..."
    
    $backupTime = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = Join-Path $Config.BackupDir $backupTime
    
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    }
    
    # Backup registry settings
    $registryBackup = @{}
    
    try {
        # Desktop wallpaper
        $wallpaper = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -ErrorAction SilentlyContinue).Wallpaper
        if ($wallpaper) {
            $registryBackup["Wallpaper"] = $wallpaper
            Copy-Item $wallpaper "$backupPath\wallpaper_backup.bmp" -ErrorAction SilentlyContinue
        }
        
        # Current theme
        $theme = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -ErrorAction SilentlyContinue).CurrentTheme
        if ($theme) {
            $registryBackup["CurrentTheme"] = $theme
        }
        
        # Colors
        $colors = @{}
        Get-ItemProperty -Path "HKCU:\Control Panel\Colors" -ErrorAction SilentlyContinue | ForEach-Object {
            $colors[$_.PSPath] = $_.PSObject.Properties.Value -join ","
        }
        $registryBackup["Colors"] = $colors | ConvertTo-Json
    } catch {
        Write-Warning "Could not backup all settings"
    }
    
    # Save backup manifest
    $manifest = @{
        Timestamp = $backupTime
        Settings = $registryBackup
        Path = $backupPath
    } | ConvertTo-Json -Depth 3
    Set-Content -Path "$backupPath\manifest.json" -Value $manifest -Encoding UTF8
    
    Write-Success "Backup created: $backupPath"
    return $backupPath
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Theme Installation
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-WindowsTheme {
    Write-Step "Installing Windows theme..."
    
    $themeSource = Join-Path $Config.SourceDir "..\themes\GitHubDark.theme"
    $themeDest = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\GitHubDark.theme"
    
    # Create themes directory if needed
    $themesDir = Split-Path $themeDest -Parent
    if (-not (Test-Path $themesDir)) {
        New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
    }
    
    # Backup existing theme
    if (Test-Path $themeDest) {
        Copy-Item $themeDest "$themeDest.backup" -Force
    }
    
    # Copy theme file
    if (Test-Path $themeSource) {
        Copy-Item $themeSource $themeDest -Force
        Write-Success "Theme installed: $themeDest"
    } else {
        Write-Warning "Theme file not found: $themeSource"
    }
    
    # Apply theme
    try {
        $rundll32 = "$env:SystemRoot\System32\rundll32.exe"
        Start-Process $rundll32 -ArgumentList "desk.cpl,InstallThemeFile", $themeDest -WindowStyle Hidden -Wait
        Write-Success "Theme applied"
    } catch {
        Write-Info "Theme file copied. Apply manually in Windows Settings."
    }
    
    # Set wallpaper
    $wallpaperSource = Join-Path $Config.SourceDir "..\wallpapers\github-dark.png"
    if (Test-Path $wallpaperSource) {
        $wallpaperDest = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\wallpaper.png"
        Copy-Item $wallpaperSource $wallpaperDest -Force
        
        # Update registry
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperDest
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 10
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -Value 0
        
        # Apply wallpaper
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
        [Wallpaper]::SystemParametersInfo(0x0014, 0, $wallpaperDest, 0x0003) | Out-Null
        
        Write-Success "Wallpaper set"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Icon Installation
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-DesktopIcons {
    Write-Step "Installing custom desktop icons..."
    
    $iconsDir = Join-Path $Config.SourceDir "..\icons\ico"
    $desktop = [Environment]::GetFolderPath("Desktop")
    
    # Define icon mappings
    $iconMappings = @{
        "desktop.ico" = "This PC"
        "folder-documents.ico" = "Documents"
        "folder-downloads.ico" = "Downloads"
    }
    
    foreach ($icon in $iconMappings.Keys) {
        $sourceIcon = Join-Path $iconsDir $icon
        $iconName = $iconMappings[$icon]
        
        # Find desktop icon
        $desktopPath = Join-Path $desktop "$iconName.lnk"
        
        if (Test-Path $desktopPath) {
            Write-Info "Found: $iconName"
            # Note: Changing system icons requires registry modifications
            # For shortcuts, we can update the icon property
            Write-Info "Icon installation for $iconName requires manual configuration"
        }
    }
    
    Write-Success "Desktop icon references noted"
    Write-Info "For custom icons: Right-click shortcut → Properties → Change Icon"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Shortcut Organization
# ═══════════════════════════════════════════════════════════════════════════════════════

function New-DeveloperFolders {
    Write-Step "Creating developer folder structure..."
    
    $home = $env:USERPROFILE
    $folders = @(
        @{ Path = "Projects"; Desc = "Coding projects" },
        @{ Path = "Repositories"; Desc = "Git repositories" },
        @{ Path = "AI"; Desc = "AI/ML projects" },
        @{ Path = "Design"; Desc = "Design files" },
        @{ Path = "Scripts"; Desc = "Utility scripts" },
        @{ Path = "Tools"; Desc = "Development tools" },
        @{ Path = "Archives"; Desc = "Archived projects" }
    )
    
    foreach ($folder in $folders) {
        $folderPath = Join-Path $home $folder.Path
        if (-not (Test-Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath -Force | Out-Null
            Write-Success "Created: $folder.Path"
        } else {
            Write-Info "Exists: $($folder.Path)"
        }
    }
}

function New-DesktopShortcuts {
    Write-Step "Creating desktop shortcuts..."
    
    $WshShell = New-Object -ComObject WScript.Shell
    $desktop = [Environment]::GetFolderPath("Desktop")
    $programs = [Environment]::GetFolderPath("Programs")
    
    # Define shortcuts to create
    $shortcuts = @(
        @{
            Name = "VS Code"
            Path = "code"
            Args = ""
            Icon = "VSCode"
        },
        @{
            Name = "Windows Terminal"
            Path = "wt"
            Args = ""
            Icon = "Terminal"
        },
        @{
            Name = "GitHub"
            Path = "https://github.com"
            Args = ""
            Icon = "Browser"
        },
        @{
            Name = "OpenHands"
            Path = "$env:LOCALAPPDATA\Programs\open-hands\openhands.exe"
            Args = ""
            Icon = "App"
        }
    )
    
    foreach ($shortcut in $shortcuts) {
        $shortcutPath = Join-Path $desktop "$($shortcut.Name).lnk"
        
        if (-not (Test-Path $shortcutPath)) {
            try {
                $ws = $WshShell.CreateShortcut($shortcutPath)
                $ws.TargetPath = $shortcut.Path
                if ($shortcut.Args) { $ws.Arguments = $shortcut.Args }
                $ws.Description = "LinkUp Studio: $($shortcut.Name)"
                $ws.WorkingDirectory = $env:USERPROFILE
                $ws.Save()
                Write-Success "Created: $($shortcut.Name)"
            } catch {
                Write-Warning "Could not create: $($shortcut.Name)"
            }
        } else {
            Write-Info "Exists: $($shortcut.Name)"
        }
    }
    
    # Pin to Start Menu
    Write-Step "Creating Start Menu shortcuts..."
    $startMenu = Join-Path $programs "LinkUp Studio"
    if (-not (Test-Path $startMenu)) {
        New-Item -ItemType Directory -Path $startMenu -Force | Out-Null
    }
    
    # Copy shortcuts to Start Menu
    foreach ($shortcut in $shortcuts) {
        $desktopShortcut = Join-Path $desktop "$($shortcut.Name).lnk"
        $startShortcut = Join-Path $startMenu "$($shortcut.Name).lnk"
        
        if (Test-Path $desktopShortcut -and -not (Test-Path $startShortcut)) {
            Copy-Item $desktopShortcut $startShortcut -Force
        }
    }
    
    Write-Success "Start Menu folder created"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Taskbar Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

function Set-TaskbarOptions {
    Write-Step "Configuring taskbar options..."
    
    # Auto-hide taskbar
    $taskbarSettings = @{
        "AutoHide" = 0
        "AlwaysOnTop" = 0
    }
    
    # Note: Taskbar settings are more complex and require Windows 10/11 API
    Write-Info "Taskbar auto-hide: Configure manually in Windows Settings"
    Write-Info "Settings → Personalization → Taskbar → Auto-hide the taskbar"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# File Association Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

function Set-FileAssociations {
    Write-Step "Configuring file associations..."
    
    # Common developer file types
    $fileTypes = @(
        ".md"  # Markdown
        ".json" # JSON
        ".yml"  # YAML
        ".yaml" # YAML
        ".ts"   # TypeScript
        ".tsx"  # TypeScript React
        ".js"   # JavaScript
        ".jsx"  # JavaScript React
        ".sql"  # SQL
    )
    
    Write-Info "File associations can be configured per-application"
    Write-Info "VS Code: Right-click file → Open with → Choose default app"
    Write-Info "Register file types in VS Code: Ctrl+Shift+P → 'Configure File Association for...'"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Registry Tweaks (Safe)
# ═══════════════════════════════════════════════════════════════════════════════════════

function Set-SafeRegistryTweaks {
    Write-Step "Applying safe registry tweaks..."
    
    # Enable dark mode for apps
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -ErrorAction SilentlyContinue
        Write-Success "Dark mode enabled for apps"
    } catch {
        Write-Warning "Could not set dark mode for apps"
    }
    
    # Enable dark mode for Windows
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -ErrorAction SilentlyContinue
        Write-Success "Dark mode enabled for Windows"
    } catch {
        Write-Warning "Could not set dark mode for Windows"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Installation
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-LinkUpStudioExperience {
    Write-Header "LinkUp Studio Windows Experience Installer"
    
    Write-Host "Version: $($Config.Version)" -ForegroundColor Gray
    Write-Host ""
    
    # Backup current settings
    Write-Step "Creating backup..."
    $backupPath = Backup-CurrentSettings
    
    # Create installation directory
    if (-not (Test-Path $Config.InstallDir)) {
        New-Item -ItemType Directory -Path $Config.InstallDir -Force | Out-Null
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " Installation" -ForegroundColor White
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    
    # Install theme
    if (-not $IconsOnly -and -not $ShortcutsOnly) {
        Install-WindowsTheme
        Set-SafeRegistryTweaks
    }
    
    # Install icons
    if (-not $ThemeOnly -and -not $ShortcutsOnly) {
        Install-DesktopIcons
    }
    
    # Create folders and shortcuts
    if (-not $ThemeOnly -and -not $IconsOnly) {
        New-DeveloperFolders
        New-DesktopShortcuts
        Set-TaskbarOptions
        Set-FileAssociations
    }
    
    # Save installation info
    $installInfo = @{
        InstalledAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Version = $Config.Version
        BackupPath = $backupPath
        Components = @()
    }
    
    if (-not $IconsOnly -and -not $ShortcutsOnly) { $installInfo.Components += "theme" }
    if (-not $ThemeOnly -and -not $ShortcutsOnly) { $installInfo.Components += "icons" }
    if (-not $ThemeOnly -and -not $IconsOnly) { $installInfo.Components += "folders"; $installInfo.Components += "shortcuts" }
    
    $installInfo | ConvertTo-Json -Depth 3 | Set-Content -Path "$($Config.InstallDir)\install_info.json" -Encoding UTF8
    
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                              ║" -ForegroundColor Green
    Write-Host "║                     Installation Complete!                                  ║" -ForegroundColor Green
    Write-Host "║                                                                              ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1. Log out and log back in for all changes to take effect" -ForegroundColor Cyan
    Write-Host "  2. Pin your favorite apps to the taskbar" -ForegroundColor Cyan
    Write-Host "  3. Arrange your desktop icons" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Backup Location: $backupPath" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Entry Point
# ═══════════════════════════════════════════════════════════════════════════════════════

try {
    Install-LinkUpStudioExperience
} catch {
    Write-Warning "Installation encountered issues: $_"
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Windows Experience Installer v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════
