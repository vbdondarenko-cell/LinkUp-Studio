# ═══════════════════════════════════════════════════════════════════════════
# LinkUp Studio Windows Terminal Installer
# Premium Developer Environment Setup
# ═══════════════════════════════════════════════════════════════════════════

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ─────────────────────────────────────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────────────────────────────────────
$ErrorActionPreference = "Stop"
$LinkUpRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor DarkGray
Write-Host "  ║      LinkUp Studio Windows Terminal Installer              ║" -ForegroundColor DarkGray
Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor DarkGray
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────
# Helper Functions
# ─────────────────────────────────────────────────────────────────────────────
function Write-Step($message) {
    Write-Host "  → $message" -ForegroundColor Cyan
}

function Write-Success($message) {
    Write-Host "  ✓ $message" -ForegroundColor Green
}

function Write-Warning($message) {
    Write-Host "  ⚠ $message" -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host "  ✗ $message" -ForegroundColor Red
}

function Write-Info($message) {
    Write-Host "  $message" -ForegroundColor Gray
}

# ─────────────────────────────────────────────────────────────────────────────
# Prerequisites Check
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "  Checking prerequisites..." -ForegroundColor White
Write-Host ""

# Check Windows Terminal
Write-Step "Checking Windows Terminal..."
$wtPath = Get-Command wt -ErrorAction SilentlyContinue
if ($wtPath) {
    Write-Success "Windows Terminal found"
} else {
    Write-Error "Windows Terminal not found. Install from Microsoft Store."
    Write-Info "winget install Microsoft.WindowsTerminal"
    exit 1
}

# Check PowerShell
Write-Step "Checking PowerShell version..."
$psVersion = $PSVersionTable.PSVersion
Write-Success "PowerShell $psVersion detected"

# Check if running as Administrator (for some operations)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# ─────────────────────────────────────────────────────────────────────────────
# Step 1: Install Oh My Posh
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Step 1: Oh My Posh Installation" -ForegroundColor White
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

Write-Step "Checking Oh My Posh..."
$omp = Get-Command oh-my-posh -ErrorAction SilentlyContinue
if (-not $omp) {
    Write-Info "Installing Oh My Posh..."
    try {
        winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
        Write-Success "Oh My Posh installed"
    } catch {
        Write-Warning "Could not install via winget. Try manually: winget install JanDeDobbeleer.OhMyPosh"
    }
} else {
    Write-Success "Oh My Posh already installed"
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 2: Install JetBrains Mono
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Step 2: JetBrains Mono Installation" -ForegroundColor White
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

Write-Step "Checking JetBrains Mono..."
$fonts = [System.Drawing.Text.InstalledFontCollection]::new()
$jetbrains = $fonts.Families | Where-Object { $_.Name -like "*JetBrains*" }
if ($jetbrains) {
    Write-Success "JetBrains Mono already installed"
} else {
    Write-Info "JetBrains Mono not found. Download from: https://www.jetbrains.com/lp/mono/"
    Write-Info "Or run: winget install JetBrains.JetBrainsMono"
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 3: Copy Windows Terminal Settings
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Step 3: Windows Terminal Settings" -ForegroundColor White
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

Write-Step "Locating Windows Terminal settings..."
$settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $settingsPath) {
    Write-Info "Found existing settings at: $settingsPath"
    
    # Backup existing settings
    $backupPath = "$settingsPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Step "Backing up existing settings..."
    Copy-Item $settingsPath $backupPath
    Write-Success "Backup created: $(Split-Path $backupPath -Leaf)"
    
    # Copy new settings
    Write-Step "Installing LinkUp Studio settings..."
    Copy-Item "$LinkUpRoot\settings.json" $settingsPath -Force
    Write-Success "Settings installed"
} else {
    Write-Warning "Could not find Windows Terminal settings"
    Write-Info "Windows Terminal may need to be launched once first"
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 4: Install PowerShell Profile
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Step 4: PowerShell Profile" -ForegroundColor White
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

Write-Step "Installing PowerShell profile..."
$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

if (Test-Path $profilePath) {
    # Check if already has LinkUp Studio content
    $existingContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    if ($existingContent -match "LinkUp Studio") {
        Write-Success "LinkUp Studio profile already installed"
    } else {
        Write-Info "Adding to existing profile..."
        Add-Content -Path $profilePath -Value "`n# LinkUp Studio`n. '$LinkUpRoot\Microsoft.PowerShell_profile.ps1'"
        Write-Success "Profile updated"
    }
} else {
    # Create new profile
    Copy-Item "$LinkUpRoot\Microsoft.PowerShell_profile.ps1" $profilePath
    Write-Success "Profile created"
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 5: Install Oh My Posh Theme
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Step 5: Oh My Posh Theme" -ForegroundColor White
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

Write-Step "Installing LinkUp theme..."
$ompPath = $env:POSH_THEMES_PATH
if ($ompPath) {
    Copy-Item "$LinkUpRoot\linkup.omp.json" $ompPath -Force
    Write-Success "Theme installed to: $ompPath"
} else {
    Write-Warning "Oh My Posh themes path not found"
    Write-Info "Theme file saved at: $LinkUpRoot\linkup.omp.json"
    Write-Info "Copy manually to: $env:USERPROFILE\AppData\Local\Programs\Oh My Posh\themes\"
}

# ─────────────────────────────────────────────────────────────────────────────
# Step 6: Create Desktop Shortcut
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  Step 6: Desktop Shortcut (Optional)" -ForegroundColor White
Write-Host "  ════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

$createShortcut = Read-Host "  Create desktop shortcut? (y/N)"
if ($createShortcut -eq "y" -or $createShortcut -eq "Y") {
    Write-Step "Creating desktop shortcut..."
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = "$desktop\LinkUp Studio Terminal.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "wt.exe"
    $Shortcut.Arguments = "-p `"Developer Dashboard`""
    $Shortcut.Description = "LinkUp Studio Developer Terminal"
    $Shortcut.Save()
    
    Write-Success "Shortcut created: $shortcutPath"
}

# ─────────────────────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════╗" -ForegroundColor DarkGray
Write-Host "  ║                  Installation Complete                     ║" -ForegroundColor DarkGray
Write-Host "  ╚═══════════════════════════════════════════════════════════╝" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Restart Windows Terminal" -ForegroundColor Gray
Write-Host "  2. Select 'Developer Dashboard' profile" -ForegroundColor Gray
Write-Host "  3. Run 'oh-my-posh init pwsh' if prompt doesn't load" -ForegroundColor Gray
Write-Host ""
Write-Host "  Git shortcuts:" -ForegroundColor White
Write-Host "    gst - git status" -ForegroundColor Gray
Write-Host "    gco - git checkout" -ForegroundColor Gray
Write-Host "    gaa - git add --all" -ForegroundColor Gray
Write-Host "    gcm - git commit -m" -ForegroundColor Gray
Write-Host ""
Write-Host "  Development functions:" -ForegroundColor White
Write-Host "    dev  - Enter developer mode" -ForegroundColor Gray
Write-Host "    sysinfo - System information" -ForegroundColor Gray
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────
# LinkUp Studio Windows Terminal Installer
# ═══════════════════════════════════════════════════════════════════════════