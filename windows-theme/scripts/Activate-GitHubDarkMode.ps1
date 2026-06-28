# ============================================
# GitHub Dark Mode Activator
# LinkUp Studio - Premium Windows Theme
# ============================================
# Run with: .\Activate-GitHubDarkMode.ps1
# Requires: PowerShell 5.1+
# ============================================

param(
    [switch]$Uninstall,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Banner {
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║   GitHub Dark Mode Activator              ║" -ForegroundColor Cyan
    Write-Host "  ║   LinkUp Studio - Premium Theme           ║" -ForegroundColor Cyan
    Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-GitHubDarkRegistry {
    Write-Host "[1/5] Configuring registry settings..." -ForegroundColor Yellow
    
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    
    # Ensure path exists
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    
    # Dark mode settings
    Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 0 -Type DWord
    Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 0 -Type DWord
    
    # Accent colors
    Set-ItemProperty -Path $regPath -Name "AccentColor" -Value 0x00feb61f -Type DWord
    Set-ItemProperty -Path $regPath -Name "ColorizationColor" -Value 0x00feb61f -Type DWord
    
    # Windows 11 specific
    Set-ItemProperty -Path $regPath -Name "IlluminationPreference" -Value "Dark" -Type String -ErrorAction SilentlyContinue
    
    Write-Host "       - Registry settings applied" -ForegroundColor Green
}

function Set-ControlPanelColors {
    Write-Host "[2/5] Setting control panel colors..." -ForegroundColor Yellow
    
    $colors = @{
        "ActiveBorder"       = "48 54 61"
        "ActiveTitle"        = "22 27 34"
        "AppWorkspace"       = "13 17 23"
        "Background"         = "13 17 23"
        "ButtonAlternateFace"= "33 38 45"
        "ButtonDkShadow"     = "27 31 36"
        "ButtonFace"         = "33 38 45"
        "ButtonHilight"      = "48 54 61"
        "ButtonLight"        = "48 54 61"
        "ButtonShadow"       = "27 31 36"
        "ButtonText"         = "230 237 243"
        "ComboBoxText"       = "230 237 243"
        "GradientActiveTitle"= "22 27 34"
        "GradientInactiveTitle" = "22 27 34"
        "GrayText"           = "110 118 129"
        "Hilight"            = "31 111 235"
        "HilightText"        = "230 237 243"
        "InactiveBorder"     = "33 38 45"
        "InactiveTitle"      = "22 27 34"
        "InactiveTitleText"  = "139 148 158"
        "InfoText"           = "230 237 243"
        "InfoWindow"         = "33 38 45"
        "Menu"               = "22 27 34"
        "MenuBar"            = "22 27 34"
        "MenuHilight"        = "31 111 235"
        "MenuText"           = "230 237 243"
        "Scrollbar"          = "48 54 61"
        "TitleText"          = "230 237 243"
        "Window"             = "22 27 34"
        "WindowFrame"        = "48 54 61"
        "WindowText"         = "230 237 243"
    }
    
    foreach ($color in $colors.GetEnumerator()) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name $color.Key -Value $color.Value -Type String -ErrorAction SilentlyContinue
    }
    
    Write-Host "       - Control panel colors set" -ForegroundColor Green
}

function Set-DWMColors {
    Write-Host "[3/5] Configuring DWM colors..." -ForegroundColor Yellow
    
    $dwmPath = "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
    
    if (-not (Test-Path $dwmPath)) {
        New-Item -Path $dwmPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $dwmPath -Name "AccentColor" -Value 0x00feb61f -Type DWord
    Set-ItemProperty -Path $dwmPath -Name "ColorizationColor" -Value 0x00feb61f -Type DWord
    Set-ItemProperty -Path $dwmPath -Name "EnableWindowColorization" -Value 1 -Type DWord
    
    Write-Host "       - DWM colors configured" -ForegroundColor Green
}

function Set-ExplorerAccent {
    Write-Host "[4/5] Setting explorer accent colors..." -ForegroundColor Yellow
    
    $explorerPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AccentColors"
    
    if (-not (Test-Path $explorerPath)) {
        New-Item -Path $explorerPath -Force | Out-Null
    }
    
    Set-ItemProperty -Path $explorerPath -Name "AccentColor" -Value 0x00feb61f -Type DWord
    Set-ItemProperty -Path $explorerPath -Name "ColorSet1" -Value 0x00e6edf3 -Type DWord
    Set-ItemProperty -Path $explorerPath -Name "HighContrastAccent" -Value 0x00feb61f -Type DWord
    Set-ItemProperty -Path $explorerPath -Name "NeutralColor" -Value 0x00e6edf3 -Type DWord
    
    Write-Host "       - Explorer accents set" -ForegroundColor Green
}

function Restart-Explorer {
    Write-Host "[5/5] Restarting Windows Explorer..." -ForegroundColor Yellow
    
    # Stop explorer
    Stop-Process -Name "explorer" -Force -ErrorAction SilentlyContinue
    
    # Wait a moment
    Start-Sleep -Milliseconds 500
    
    # Start explorer
    Start-Process -FilePath "explorer.exe"
    
    Write-Host "       - Explorer restarted" -ForegroundColor Green
}

function Enable-DarkMode {
    param([switch]$Force)
    
    Write-Banner
    
    if (-not (Test-Administrator)) {
        Write-Host "[ERROR] Please run this script as Administrator" -ForegroundColor Red
        Write-Host "        Right-click and select 'Run as administrator'" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host "Installing GitHub Dark Mode..." -ForegroundColor Cyan
    Write-Host ""
    
    try {
        Set-GitHubDarkRegistry
        Set-ControlPanelColors
        Set-DWMColors
        Set-ExplorerAccent
        Restart-Explorer
        
        Write-Host ""
        Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
        Write-Host "  GitHub Dark Mode Activated Successfully!" -ForegroundColor Green
        Write-Host "═══════════════════════════════════════════" -ForegroundColor Green
        Write-Host ""
        Write-Host "The dark theme is now active." -ForegroundColor White
        Write-Host "Some changes may require a restart to take full effect." -ForegroundColor Gray
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "[ERROR] Failed to apply dark mode: $_" -ForegroundColor Red
        exit 1
    }
}

function Disable-DarkMode {
    Write-Banner
    
    if (-not (Test-Administrator)) {
        Write-Host "[ERROR] Please run this script as Administrator" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    Write-Host "Reverting to Light Mode..." -ForegroundColor Cyan
    Write-Host ""
    
    # Reset registry
    $regPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 1 -Type DWord
    Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 1 -Type DWord
    
    # Reset accent
    Set-ItemProperty -Path $regPath -Name "AccentColor" -Value 0x00d0902c -Type DWord
    Set-ItemProperty -Path $regPath -Name "ColorizationColor" -Value 0x00d0902c -Type DWord
    
    # Reset control panel
    $defaultColors = @{
        "ActiveTitle"  = "0 114 198"
        "Background"   = "0 74 144"
        "ButtonFace"   = "240 240 240"
        "ButtonText"   = "0 0 0"
        "Window"       = "255 255 255"
        "WindowText"   = "0 0 0"
    }
    
    foreach ($color in $defaultColors.GetEnumerator()) {
        Set-ItemProperty -Path "HKCU:\Control Panel\Colors" -Name $color.Key -Value $color.Value -Type String -ErrorAction SilentlyContinue
    }
    
    Restart-Explorer
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host "  GitHub Dark Mode Deactivated" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host ""
}

# Main execution
if ($Uninstall) {
    Disable-DarkMode
} else {
    Enable-DarkMode -Force:$Force
}