# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Windows Experience Uninstaller
# Restore Previous Windows Settings
# ═══════════════════════════════════════════════════════════════════════════════════════

[CmdletBinding()]
param(
    [switch]$Restore,
    [switch]$CleanAll,
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = @{
    AppName = "LinkUp Studio Experience"
    InstallDir = "$env:LOCALAPPDATA\LinkUpStudio\WindowsExperience"
    BackupDir = "$env:LOCALAPPDATA\LinkUpStudio\Backups"
    ThemeName = "GitHubDark"
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
# Uninstall Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Get-AvailableBackups {
    $backups = @()
    
    if (Test-Path $Config.BackupDir) {
        Get-ChildItem -Path $Config.BackupDir -Directory | Sort-Object Name -Descending | ForEach-Object {
            $manifestPath = Join-Path $_.FullName "manifest.json"
            if (Test-Path $manifestPath) {
                $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
                $backups += @{
                    Timestamp = $manifest.Timestamp
                    Path = $_.FullName
                    Settings = $manifest.Settings
                }
            } else {
                $backups += @{
                    Timestamp = $_.Name
                    Path = $_.FullName
                    Settings = @{}
                }
            }
        }
    }
    
    return $backups
}

function Restore-Backup {
    param([string]$BackupPath)
    
    Write-Step "Restoring settings from: $BackupPath"
    
    $manifestPath = Join-Path $BackupPath "manifest.json"
    if (-not (Test-Path $manifestPath)) {
        Write-Warning "No manifest found in backup"
        return $false
    }
    
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
    
    # Restore wallpaper
    $wallpaperBackup = Join-Path $BackupPath "wallpaper_backup.bmp"
    if (Test-Path $wallpaperBackup) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperBackup
        
        # Apply wallpaper
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
        [Wallpaper]::SystemParametersInfo(0x0014, 0, $wallpaperBackup, 0x0003) | Out-Null
        Write-Success "Wallpaper restored"
    }
    
    # Restore theme
    $themePath = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\GitHubDark.theme"
    if (Test-Path "$themePath.backup") {
        Copy-Item "$themePath.backup" $themePath -Force
        Write-Info "Theme backup restored"
    }
    
    # Restore registry settings
    if ($manifest.Settings) {
        # Restore colors if saved
        Write-Info "Registry settings noted for manual restore"
    }
    
    return $true
}

function Remove-LinkUpStudioExperience {
    Write-Header "LinkUp Studio Windows Experience Uninstaller"
    
    Write-Host "This will remove LinkUp Studio Windows customizations." -ForegroundColor Yellow
    Write-Host ""
    
    # List available backups
    $backups = Get-AvailableBackups
    $latestBackup = $backups | Select-Object -First 1
    
    if ($Restore -and $latestBackup) {
        Write-Host "Latest backup: $($latestBackup.Timestamp)" -ForegroundColor Gray
        Write-Host ""
        
        $confirm = Read-Host "Restore settings from this backup? (Y/n)"
        if ($confirm -ne "n" -and $confirm -ne "N") {
            Restore-Backup -BackupPath $latestBackup.Path
        }
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " Removing Components" -ForegroundColor White
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    
    # Remove theme
    Write-Step "Removing Windows theme..."
    $themePath = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\GitHubDark.theme"
    if (Test-Path $themePath) {
        Remove-Item $themePath -Force -ErrorAction SilentlyContinue
        Write-Success "Theme removed"
    }
    
    # Restore Windows default theme
    try {
        $defaultTheme = "$env:SystemRoot\Resources\Themes\aero.theme"
        if (Test-Path $defaultTheme) {
            # Apply default theme
            Start-Process "$env:SystemRoot\System32\rundll32.exe" -ArgumentList "desk.cpl,InstallThemeFile", $defaultTheme -Wait -WindowStyle Hidden
            Write-Info "Default theme applied"
        }
    } catch {
        Write-Info "Please manually select a theme in Windows Settings"
    }
    
    # Remove wallpaper
    Write-Step "Restoring default wallpaper..."
    try {
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value ""
        Write-Info "Wallpaper reference cleared"
    } catch {
        Write-Warning "Could not restore wallpaper"
    }
    
    # Remove desktop shortcuts
    Write-Step "Removing LinkUp Studio shortcuts..."
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutsToRemove = @(
        "VS Code",
        "Windows Terminal",
        "GitHub",
        "OpenHands"
    )
    
    foreach ($name in $shortcutsToRemove) {
        $shortcutPath = Join-Path $desktop "$name.lnk"
        if (Test-Path $shortcutPath) {
            try {
                Remove-Item $shortcutPath -Force
                Write-Info "Removed: $name"
            } catch {
                Write-Warning "Could not remove: $name"
            }
        }
    }
    
    # Remove Start Menu folder
    Write-Step "Removing Start Menu folder..."
    $startMenu = [Environment]::GetFolderPath("StartMenu")
    $linkupFolder = Join-Path $startMenu "Programs\LinkUp Studio"
    if (Test-Path $linkupFolder) {
        Remove-Item $linkupFolder -Recurse -Force
        Write-Success "Start Menu folder removed"
    }
    
    # Remove developer folders (optional)
    Write-Step "Checking developer folders..."
    $home = $env:USERPROFILE
    $devFolders = @("Projects", "Repositories", "AI", "Design", "Scripts", "Tools", "Archives")
    
    $confirm = Read-Host "Remove developer folders? (y/N)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        foreach ($folder in $devFolders) {
            $folderPath = Join-Path $home $folder
            if (Test-Path $folderPath) {
                # Check if empty
                if ((Get-ChildItem $folderPath -Force -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0) {
                    Remove-Item $folderPath -Force
                    Write-Info "Removed empty folder: $folder"
                } else {
                    Write-Warning "Folder not empty, skipping: $folder"
                }
            }
        }
    }
    
    # Restore light mode
    if (-not $CleanAll) {
        Write-Step "Restoring light mode preference..."
        try {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1 -ErrorAction SilentlyContinue
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1 -ErrorAction SilentlyContinue
            Write-Info "Light mode preference restored"
        } catch {
            Write-Warning "Could not restore light mode"
        }
    }
    
    # Clean installation directory
    if ($CleanAll) {
        Write-Step "Cleaning installation files..."
        if (Test-Path $Config.InstallDir) {
            Remove-Item $Config.InstallDir -Recurse -Force -ErrorAction SilentlyContinue
            Write-Success "Installation directory cleaned"
        }
    }
    
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                              ║" -ForegroundColor Green
    Write-Host "║                       Uninstallation Complete!                               ║" -ForegroundColor Green
    Write-Host "║                                                                              ║" -ForegroundColor Green
    Write-Host "╚═══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Entry Point
# ═══════════════════════════════════════════════════════════════════════════════════════

try {
    Remove-LinkUpStudioExperience
} catch {
    Write-Warning "Uninstallation encountered issues: $_"
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Windows Experience Uninstaller v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════
