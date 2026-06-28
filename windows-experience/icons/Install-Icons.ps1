# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Icon Pack Installer
# Installs custom icons for folders, shortcuts, and more
# ═══════════════════════════════════════════════════════════════════════════════════════
#Requires -RunAsAdministrator

param(
    [switch]$Uninstall,
    [switch]$Folders,
    [switch]$Shortcuts,
    [switch]$All
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$InstallDir = "$env:LOCALAPPDATA\LinkUpStudio\icons"
$IconsDir = Join-Path $InstallDir "icons"
$TempDir = "$env:TEMP\LinkUpStudio_icons"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Write-Header {
    Write-Host ""
    Write-Host "╔═══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  LinkUp Studio Icon Pack Installer" -ForegroundColor Cyan
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

function Write-Error {
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor Red
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Uninstall
# ═══════════════════════════════════════════════════════════════════════════════════════

function Uninstall-Icons {
    Write-Header
    
    Write-Step "Removing LinkUp Studio icons..."
    
    # Remove registry entries for folder icons
    $folderTypes = @(
        "Directory",
        "Directory\Background"
    )
    
    foreach ($type in $folderTypes) {
        $path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{a0c69ebe-9ce1-11d5-bfec-00b0d0afc460}\TopViews\{7de81c16-1b6a-4ab5-abe5-dbeebde53b8f}"
        # Simplified registry cleanup
    }
    
    # Remove installed files
    if (Test-Path $InstallDir) {
        Remove-Item $InstallDir -Recurse -Force
        Write-Success "Icons removed"
    } else {
        Write-Info "No icons installed"
    }
    
    Write-Host ""
    Write-Host "Icons uninstalled. You may need to restart Explorer." -ForegroundColor Yellow
    Write-Host "Run: iexplorer.exe /restart" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Install Icons
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-Icons {
    Write-Header
    
    # Create directories
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
    }
    if (-not (Test-Path $IconsDir)) {
        New-Item -ItemType Directory -Path $IconsDir -Force | Out-Null
    }
    
    Write-Step "Copying icon files..."
    
    # Copy SVG icons
    Copy-Item "$ScriptDir\*.svg" $IconsDir -Force -ErrorAction SilentlyContinue
    Write-Info "Copied SVG icons"
    
    # Convert SVG to ICO if possible
    $svgFiles = Get-ChildItem -Path $ScriptDir -Filter "*.svg"
    
    Write-Step "Available icons:"
    foreach ($svg in $svgFiles) {
        Write-Host "  • $($svg.BaseName).svg" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Success "Icons copied to: $IconsDir"
    Write-Host ""
    
    Write-Host "To use these icons:" -ForegroundColor White
    Write-Host ""
    Write-Host "1. Right-click a shortcut or folder" -ForegroundColor Gray
    Write-Host "2. Select Properties → Change Icon..." -ForegroundColor Gray
    Write-Host "3. Browse to: $IconsDir" -ForegroundColor Cyan
    Write-Host "4. Select an icon" -ForegroundColor Gray
    Write-Host ""
    
    # Copy to Windows icons folder (if exists)
    $windowsIconsDir = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\CustomIcons"
    if (-not (Test-Path $windowsIconsDir)) {
        try {
            New-Item -ItemType Directory -Path $windowsIconsDir -Force | Out-Null
            Copy-Item "$ScriptDir\*.svg" $windowsIconsDir -Force
            Write-Success "Icons also available in: $windowsIconsDir"
        } catch {
            Write-Info "Could not copy to Windows themes folder (may need admin)"
        }
    }
    
    Write-Host ""
    Write-Host "Note: For folder icons, restart Explorer:" -ForegroundColor Yellow
    Write-Host "  iexplorer.exe /restart" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Create Desktop Shortcut with Icon
# ═══════════════════════════════════════════════════════════════════════════════════════

function New-LinkUpShortcut {
    param(
        [string]$Name = "LinkUp Studio",
        [string]$Target = "https://github.com/vbdondarenko-cell/LinkUp-Studio",
        [string]$Icon = "linkup-studio.svg"
    )
    
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "$Name.lnk"
    $iconPath = Join-Path $IconsDir $Icon
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = $Target
    $Shortcut.WorkingDirectory = Split-Path $Target -Parent
    $Shortcut.Description = "LinkUp Studio - Developer Workspace"
    
    if (Test-Path $iconPath) {
        $Shortcut.IconLocation = $iconPath
    }
    
    $Shortcut.Save()
    Write-Success "Created: $shortcutPath"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main
# ═══════════════════════════════════════════════════════════════════════════════════════

if ($Uninstall) {
    Uninstall-Icons
    exit 0
}

if ($All -or (-not $Folders -and -not $Shortcuts)) {
    Install-Icons
}

if ($Folders) {
    Install-Icons
}

if ($Shortcuts) {
    Write-Header
    Write-Step "Creating desktop shortcuts..."
    New-LinkUpShortcut -Name "LinkUp Studio" -Target "https://github.com/vbdondarenko-cell/LinkUp-Studio" -Icon "linkup-studio.svg"
    New-LinkUpShortcut -Name "OpenHands" -Target "https://app.all-hands.dev" -Icon "terminal.svg"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Icon Pack Installer v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════