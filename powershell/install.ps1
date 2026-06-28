# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio PowerShell Installer
# Premium Developer Experience Setup
# ═══════════════════════════════════════════════════════════════════════════════════════

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║                                                                              ║" -ForegroundColor Cyan
Write-Host "  ║    ██╗    ██╗  ██████╗  ██████╗  ██████╗     ███╗   ███╗ ██████╗ ██████╗   ║" -ForegroundColor Cyan
Write-Host "  ║    ██║    ██║ ██╔════╝ ██╔════╝ ██╔═══██╗    ████╗ ████║██╔═══██╗██╔══██╗  ║" -ForegroundColor Cyan
Write-Host "  ║    ██║ █╗ ██║ ██║  ███╗██║  ███╗██║   ██║    ██╔████╔██║██║   ██║██║  ██║  ║" -ForegroundColor Cyan
Write-Host "  ║    ██║███╗██║ ██║   ██║██║   ██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║  ║" -ForegroundColor Cyan
Write-Host "  ║    ╚██████╔╝ ╚██████╔╝╚██████╔╝╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝  ║" -ForegroundColor Cyan
Write-Host "  ║     ╚═══██╔╝   ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝   ║" -ForegroundColor Cyan
Write-Host "  ║                                                                              ║" -ForegroundColor Cyan
Write-Host "  ║              Premium PowerShell Experience Installer                        ║" -ForegroundColor Cyan
Write-Host "  ║                                                                              ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────────────
$LinkUpRoot = "https://raw.githubusercontent.com/vbdondarenko-cell/LinkUp-Studio/main/powershell"
$ProfilePath = $PROFILE
$ProfileDir = Split-Path -Parent $ProfilePath -ErrorAction SilentlyContinue

# ─────────────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────────────
function Write-Step($message) {
    Write-Host "  [→] $message" -ForegroundColor Cyan
}

function Write-Success($message) {
    Write-Host "  [✓] $message" -ForegroundColor Green
}

function Write-Warning($message) {
    Write-Host "  [!] $message" -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host "  [✗] $message" -ForegroundColor Red
}

function Write-Info($message) {
    Write-Host "  [i] $message" -ForegroundColor Gray
}

# ─────────────────────────────────────────────────────────────────────────────────────
# System Check
# ─────────────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  System Check..." -ForegroundColor White
Write-Host ""

# PowerShell Version
Write-Step "PowerShell Version"
Write-Info "PowerShell $($PSVersionTable.PSVersion) ($($PSVersionTable.PSEdition))"
if ($PSVersionTable.PSVersion.Major -ge 5) {
    Write-Success "PowerShell version OK"
} else {
    Write-Error "PowerShell 5.1 or higher required"
}

# Git Check
Write-Step "Git Installation"
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    $gitVersion = (git --version) -replace "git version ", ""
    Write-Info "Git $gitVersion detected"
    Write-Success "Git is installed"
} else {
    Write-Warning "Git not detected - some features will be limited"
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Oh My Posh Check
# ─────────────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Step "Oh My Posh"
$omp = Get-Command oh-my-posh -ErrorAction SilentlyContinue
if ($omp) {
    Write-Info "Oh My Posh is installed"
    Write-Success "Oh My Posh ready"
} else {
    Write-Info "Oh My Posh not installed"
    Write-Info "Install with: winget install JanDeDobbeleer.OhMyPosh"
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Profile Installation
# ─────────────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Profile Installation" -ForegroundColor White
Write-Host "  ═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

# Create profile directory
Write-Step "Creating profile directory"
if ($ProfileDir -and !(Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    Write-Success "Created: $ProfileDir"
} else {
    Write-Info "Directory exists: $ProfileDir"
}

# Backup existing profile
if (Test-Path $ProfilePath) {
    Write-Step "Backing up existing profile"
    $backupPath = "$ProfilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item $ProfilePath $backupPath -Force
    Write-Success "Backup: $backupPath"
    
    # Check if already has LinkUp Studio
    $content = Get-Content $ProfilePath -Raw -ErrorAction SilentlyContinue
    if ($content -match "LinkUp Studio") {
        Write-Warning "LinkUp Studio profile already installed"
        $continue = Read-Host "  Overwrite existing profile? (y/N)"
        if ($continue -ne "y" -and $continue -ne "Y") {
            Write-Info "Installation cancelled"
            exit 0
        }
    }
}

# Download profile
Write-Step "Downloading LinkUp Studio profile"
try {
    $profileUrl = "$LinkUpRoot/Microsoft.PowerShell_profile.ps1"
    $response = Invoke-WebRequest -Uri $profileUrl -UseBasicParsing -TimeoutSec 30
    
    # Create the profile file
    $profileContent = $response.Content
    
    # Check if profile directory exists
    if (!(Test-Path $ProfileDir)) {
        New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    }
    
    Set-Content -Path $ProfilePath -Value $profileContent -Force -Encoding UTF8
    Write-Success "Profile installed"
    Write-Info "Location: $ProfilePath"
} catch {
    Write-Warning "Could not download profile automatically"
    Write-Info "Please copy Microsoft.PowerShell_profile.ps1 manually"
    Write-Info "To: $ProfilePath"
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Oh My Posh Theme
# ─────────────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Step "Installing Oh My Posh theme"
$ompPath = $env:POSH_THEMES_PATH
if ($ompPath) {
    try {
        $themeUrl = "$LinkUpRoot/../windows-terminal/linkup.omp.json"
        $themeResponse = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vbdondarenko-cell/LinkUp-Studio/main/windows-terminal/linkup.omp.json" -UseBasicParsing -TimeoutSec 30
        $themePath = Join-Path $ompPath "linkup.omp.json"
        Set-Content -Path $themePath -Value $themeResponse.Content -Force -Encoding UTF8
        Write-Success "Theme installed: $themePath"
    } catch {
        Write-Warning "Could not install theme"
    }
} else {
    Write-Info "Oh My Posh not installed - theme skipped"
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Create Desktop Shortcut
# ─────────────────────────────────────────────────────────────────────────────────────
Write-Host ""
$createShortcut = Read-Host "  Create PowerShell shortcut on Desktop? (y/N)"
if ($createShortcut -eq "y" -or $createShortcut -eq "Y") {
    Write-Step "Creating desktop shortcut"
    
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "LinkUp Studio PowerShell.lnk"
    
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($shortcutPath)
        $Shortcut.TargetPath = "pwsh.exe"
        $Shortcut.Arguments = "-NoLogo -NoExit"
        $Shortcut.Description = "LinkUp Studio Premium PowerShell"
        $Shortcut.WorkingDirectory = $env:USERPROFILE
        $Shortcut.Save()
        Write-Success "Shortcut created: $shortcutPath"
    } catch {
        Write-Warning "Could not create shortcut"
    }
}

# ─────────────────────────────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║                                                                              ║" -ForegroundColor Cyan
Write-Host "  ║                         Installation Complete!                               ║" -ForegroundColor Cyan
Write-Host "  ║                                                                              ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Next Steps:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Close and reopen PowerShell" -ForegroundColor Gray
Write-Host "  2. The LinkUp Studio banner will appear on startup" -ForegroundColor Gray
Write-Host "  3. Type 'dev' anytime to refresh the dashboard" -ForegroundColor Gray
Write-Host ""
Write-Host "  Available Commands:" -ForegroundColor White
Write-Host "    dev          - Show developer dashboard" -ForegroundColor Gray
Write-Host "    gst          - Git status" -ForegroundColor Gray
Write-Host "    gco          - Git checkout" -ForegroundColor Gray
Write-Host "    gaa          - Git add all" -ForegroundColor Gray
Write-Host "    gcm          - Git commit" -ForegroundColor Gray
Write-Host "    sys          - System information" -ForegroundColor Gray
Write-Host ""
Write-Host "  Node.js: ni, nr, nrb, nrd" -ForegroundColor Gray
Write-Host "  Docker:  dps, dexec, dlogs" -ForegroundColor Gray
Write-Host "  Python:  pa, pipi, pact" -ForegroundColor Gray
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────────────
# LinkUp Studio PowerShell Installer
# ═══════════════════════════════════════════════════════════════════════════════════════