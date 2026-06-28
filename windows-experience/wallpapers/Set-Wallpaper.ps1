# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Wallpaper Installer
# Installs LinkUp Studio themed wallpapers
# ═══════════════════════════════════════════════════════════════════════════════════════

param(
    [ValidateSet("linkup-dark", "linkup-minimal", "github-dark")]
    [string]$Wallpaper = "linkup-dark",
    [ValidateSet("fill", "fit", "center", "stretch", "tile")]
    [string]$Style = "fill"
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$WallpaperSource = Join-Path $ScriptDir "$Wallpaper.svg"
$WallpaperDest = Join-Path $env:TEMP "LinkUpStudio_wallpaper.png"
$InstallDir = "$env:LOCALAPPDATA\LinkUpStudio\wallpapers"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  $Title" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "[→] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[✓] $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[i] $Message" -ForegroundColor Gray
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Installation
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Header "LinkUp Studio Wallpaper Installer"

# Create install directory
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    Write-Info "Created: $InstallDir"
}

# Check for SVG source
if (Test-Path $WallpaperSource) {
    Write-Step "Converting SVG to PNG..."
    
    try {
        # Try using Inkscape if available
        $inkscape = Get-Command inkscape -ErrorAction SilentlyContinue
        if ($inkscape) {
            & $inkscape -w 3840 -h 2160 -o $WallpaperDest $WallpaperSource
            Write-Success "Converted using Inkscape"
        }
    } catch {
        Write-Info "Inkscape not found, copying SVG instead"
        $WallpaperDest = Join-Path $InstallDir "$Wallpaper.svg"
    }
    
    # Copy file
    Copy-Item $WallpaperSource $WallpaperDest -Force
    Write-Success "Wallpaper installed: $WallpaperDest"
} else {
    Write-Host "Source wallpaper not found: $WallpaperSource" -ForegroundColor Yellow
    Write-Host "Available wallpapers:" -ForegroundColor Yellow
    Get-ChildItem -Path $ScriptDir -Filter "*.svg" | ForEach-Object {
        Write-Host "  - $($_.BaseName)" -ForegroundColor Gray
    }
    exit 1
}

# Copy all wallpapers to install directory
Write-Step "Copying all wallpapers to install directory..."
Copy-Item "$ScriptDir\*.svg" $InstallDir -Force
Copy-Item "$ScriptDir\*.png" $InstallDir -Force -ErrorAction SilentlyContinue
Write-Success "All wallpapers copied"

# Set as desktop wallpaper
Write-Step "Setting as desktop wallpaper..."

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Wallpaper style constants
$styleValues = @{
    "fill" = 10
    "fit" = 6
    "center" = 0
    "stretch" = 2
    "tile" = 1
}

# Set wallpaper
$spiSetDeskWallpaper = 0x0014
$updateIniFile = 0x01
$sendChangeNotify = 0x02
$flags = $updateIniFile -bor $sendChangeNotify

[Wallpaper]::SystemParametersInfo($spiSetDeskWallpaper, 0, $WallpaperDest, $flags)

# Set style
$regPath = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $regPath -Name WallpaperStyle -Value $styleValues[$Style]
Set-ItemProperty -Path $regPath -Name TileWallpaper -Value 0

Write-Success "Desktop wallpaper set!"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Available Wallpapers
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "Available wallpapers in $InstallDir :" -ForegroundColor White
Get-ChildItem -Path $InstallDir -Filter "*.svg" | ForEach-Object {
    Write-Host "  • $($_.Name)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Usage:" -ForegroundColor White
Write-Host "  .\Set-Wallpaper.ps1 -Wallpaper linkup-dark" -ForegroundColor Gray
Write-Host "  .\Set-Wallpaper.ps1 -Wallpaper linkup-minimal -Style fit" -ForegroundColor Gray
Write-Host ""

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Wallpaper Installer v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════