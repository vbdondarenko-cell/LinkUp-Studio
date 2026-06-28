# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Startup Configuration
# Launches everything after Windows login in under 10 seconds
# ═══════════════════════════════════════════════════════════════════════════════════════
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [switch]$Disable,
    [switch]$Enable,
    [switch]$Status,
    [switch]$SkipBrowser,
    [switch]$SkipOpenHands,
    [switch]$Silent
)

$ErrorActionPreference = "Stop"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = @{
    AppName = "LinkUp Studio Startup"
    StartupName = "LinkUpStudio"
    StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    ConfigDir = "$env:LOCALAPPDATA\LinkUpStudio"
    StartupScript = "$env:LOCALAPPDATA\LinkUpStudio\startup.bat"
    ConfigFile = "$env:LOCALAPPDATA\LinkUpStudio\startup_config.json"
    MaxStartupTime = 10  # seconds
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
}

function Write-Success {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[✓] $Message" -ForegroundColor Green
    }
}

function Write-Warning {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[!] $Message" -ForegroundColor Yellow
    }
}

function Write-Info {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[i] $Message" -ForegroundColor Gray
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration Management
# ═══════════════════════════════════════════════════════════════════════════════════════

function Get-StartupConfig {
    if (Test-Path $Config.ConfigFile) {
        try {
            return Get-Content $Config.ConfigFile -Raw | ConvertFrom-Json -AsHashtable
        } catch {
            return @{}
        }
    }
    return @{}
}

function Save-StartupConfig {
    param([hashtable]$Config)
    
    $configDir = Split-Path $Config.ConfigFile -Parent
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    $Config | ConvertTo-Json -Depth 3 | Set-Content -Path $Config.ConfigFile -Encoding UTF8
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Startup Script Generator
# ═══════════════════════════════════════════════════════════════════════════════════════

function New-StartupScript {
    param(
        [string]$OpenHandsPath = "",
        [string]$BrowserURL = "",
        [string]$ProjectPath = "",
        [switch]$WaitForServices
    )
    
    $script = @"
@echo off
:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Fast Startup Script
:: Optimized for < 10 second startup time
:: ═══════════════════════════════════════════════════════════════════════════════════════
setlocal enabledelayedexpansion

set "START_TIME=%TIME%"
set "LINKUP_DIR=%LOCALAPPDATA%\LinkUpStudio"

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Quick Services Check (optional - runs in background)
:: ═══════════════════════════════════════════════════════════════════════════════════════

REM Start services check in background if enabled
REM Services are checked asynchronously to not block startup

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Step 1: Launch Windows Terminal with LinkUp Studio (immediate)
:: ═══════════════════════════════════════════════════════════════════════════════════════

start "" wt.exe -p "Developer Dashboard" --maximized

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Step 2: Launch OpenHands (parallel)
:: ═══════════════════════════════════════════════════════════════════════════════════════

$(if ($OpenHandsPath) {
@"
start "" "$OpenHandsPath"
"@
} else {
@"
start "" "openhands.exe"
start "" "openhands-app.exe"
"@
})

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Step 3: Launch Browser with previous project (after 1 second delay for services)
:: ═══════════════════════════════════════════════════════════════════════════════════════

REM Wait 1 second for services to stabilize
timeout /t 1 /nobreak >nul

$(if ($BrowserURL) {
@"
start "" "$BrowserURL"
"@
} else {
@"
REM Default: Open OpenHands cloud or localhost
start "" "http://app.all-hands.dev"
"@
})

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: Calculate startup time
:: ═══════════════════════════════════════════════════════════════════════════════════════

set "END_TIME=%TIME%"
set "ELAPSED=Calculated at startup"

:: ═══════════════════════════════════════════════════════════════════════════════════════
:: LinkUp Studio Startup v1.0.0
:: ═══════════════════════════════════════════════════════════════════════════════════════
"@
    
    return $script
}

function New-AdvancedStartupScript {
    param(
        [string]$OpenHandsPath = "",
        [string]$BrowserURL = "",
        [string]$ProjectPath = "",
        [switch]$WaitForServices
    )
    
    # Generate PowerShell launch script for better performance
    $psScript = @"
# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Fast Startup - PowerShell Edition
# Uses Start-Process for parallel execution and measures startup time
# ═══════════════════════════════════════════════════════════════════════════════════════

$ErrorActionPreference = "SilentlyContinue"
$StartTime = Get-Date

function Write-StartupLog {
    param([string]`$Message)
    `$LogFile = "`$env:LOCALAPPDATA`\LinkUpStudio\startup.log"
    `"`$(Get-Date -Format 'HH:mm:ss') - `$Message`" | Add-Content -Path `$LogFile -Encoding UTF8
}

Write-StartupLog "Startup initiated"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Pre-flight checks
# ═══════════════════════════════════════════════════════════════════════════════════════

$(if ($WaitForServices) {
@"
# Wait for critical services (max 3 seconds)
Write-StartupLog "Checking services..."

# Check Windows Terminal service
`$wtReady = `$false
for (`$i = 0; `$i -lt 30; `$i++) {
    if (Get-Process -Name "WindowsTerminal" -ErrorAction SilentlyContinue) {
        `$wtReady = `$true
        break
    }
    Start-Sleep -Milliseconds 100
}

# Check if running as expected - proceed regardless
Write-StartupLog "Services check completed"
"@
} else {
@"
# Skip service checks for maximum speed
Write-StartupLog "Skipping service checks for fast startup"
"@
})

# ═══════════════════════════════════════════════════════════════════════════════════════
# Launch Applications in Parallel (Stage 1 - Immediate)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-StartupLog "Launching Stage 1 applications..."

# Windows Terminal with LinkUp Studio
Start-Process -FilePath "wt.exe" -ArgumentList "-p `"Developer Dashboard`" --maximized" -WindowStyle Normal
Write-StartupLog "Windows Terminal launched"

# OpenHands
$(if ($OpenHandsPath -and (Test-Path $OpenHandsPath)) {
@"
Start-Process -FilePath "$OpenHandsPath" -WindowStyle Normal
Write-StartupLog "OpenHands launched: $OpenHandsPath"
"@
} else {
@"
# Try common OpenHands locations
`$openHandsPaths = @(
    "`$env:LOCALAPPDATA`\Programs\open-hands\openhands.exe",
    "`$env:LOCALAPPDATA`\open-hands\openhands.exe",
    "openhands.exe",
    "openhands-app.exe"
)

foreach (`$path in `$openHandsPaths) {
    if (Test-Path `$path) {
        Start-Process -FilePath `$path -WindowStyle Normal
        Write-StartupLog "OpenHands launched: `$path"
        break
    }
}
"@
})

# ═══════════════════════════════════════════════════════════════════════════════════════
# Launch Browser (Stage 2 - After 500ms for services)
# ═══════════════════════════════════════════════════════════════════════════════════════

Start-Sleep -Milliseconds 500

Write-StartupLog "Launching Stage 2 applications..."

$(if ($BrowserURL) {
@"
Start-Process -FilePath "$BrowserURL"
Write-StartupLog "Browser launched: $BrowserURL"
"@
} else {
@"
# Default to OpenHands cloud
Start-Process -FilePath "http://app.all-hands.dev"
Write-StartupLog "Browser launched: app.all-hands.dev"
"@
})

# ═══════════════════════════════════════════════════════════════════════════════════════
# Restore Project (Stage 3 - After additional delay)
# ═══════════════════════════════════════════════════════════════════════════════════════

$(if ($ProjectPath -and (Test-Path $ProjectPath)) {
@"
Start-Sleep -Milliseconds 500
Write-StartupLog "Opening project: $ProjectPath"

# Open project in Windows Terminal
Start-Process -FilePath "wt.exe" -ArgumentList "split-pane; cd `"$ProjectPath`"" -WindowStyle Normal
Write-StartupLog "Project opened"
"@
} else {
@"
Write-StartupLog "No project path configured"
"@
})

# ═══════════════════════════════════════════════════════════════════════════════════════
# Calculate and report startup time
# ═══════════════════════════════════════════════════════════════════════════════════════

`$EndTime = Get-Date
`$Elapsed = (`$EndTime - `$StartTime).TotalSeconds
Write-StartupLog "Startup completed in `$(`$Elapsed.ToString('0.0')) seconds"

if (`$Elapsed -gt 10) {
    Write-StartupLog "WARNING: Startup exceeded 10 second target"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Fast Startup - PowerShell Edition v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════
"@
    
    return $psScript
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Startup Registration
# ═══════════════════════════════════════════════════════════════════════════════════════

function Register-Startup {
    param(
        [string]$OpenHandsPath = "",
        [string]$BrowserURL = "",
        [string]$ProjectPath = "",
        [switch]$WaitForServices
    )
    
    Write-Header "LinkUp Studio Startup Configuration"
    
    # Create config directory
    if (-not (Test-Path $Config.ConfigDir)) {
        New-Item -ItemType Directory -Path $Config.ConfigDir -Force | Out-Null
    }
    
    # Generate startup scripts
    Write-Step "Generating startup scripts..."
    
    # Save configuration
    $startupConfig = @{
        Enabled = $true
        OpenHandsPath = $OpenHandsPath
        BrowserURL = $BrowserURL
        ProjectPath = $ProjectPath
        WaitForServices = $WaitForServices.IsPresent
        ConfiguredAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        MaxStartupTime = $Config.MaxStartupTime
    }
    Save-StartupConfig -Config $startupConfig
    
    # Generate and save PowerShell startup script
    $psScript = New-AdvancedStartupScript `
        -OpenHandsPath $OpenHandsPath `
        -BrowserURL $BrowserURL `
        -ProjectPath $ProjectPath `
        -WaitForServices:$WaitForServices
    
    $psScriptPath = "$Config.ConfigDir\LinkUp-Studio-Startup.ps1"
    $psScript | Set-Content -Path $psScriptPath -Encoding UTF8
    
    # Generate batch launcher for Startup folder
    $batScript = @"
@echo off
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%LOCALAPPDATA%\LinkUpStudio\LinkUp-Studio-Startup.ps1"
"@
    
    $batScriptPath = "$Config.StartupScript"
    $batScript | Set-Content -Path $batScriptPath -Encoding ASCII
    
    # Create startup shortcut
    $startupShortcut = "$Config.StartupPath\LinkUp Studio.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($startupShortcut)
    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$psScriptPath`""
    $Shortcut.Description = "LinkUp Studio - Fast Startup"
    $Shortcut.WorkingDirectory = $env:LOCALAPPDATA
    $Shortcut.Save()
    
    Write-Success "Startup shortcut created: $startupShortcut"
    Write-Info "Startup script: $psScriptPath"
    
    # Create uninstaller entry in Start Menu
    $uninstallScript = @"
@echo off
:: Remove LinkUp Studio from Windows startup
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\LinkUp Studio.lnk"
echo LinkUp Studio removed from startup.
pause
"@
    
    $uninstallBatPath = "$Config.ConfigDir\Disable-Startup.bat"
    $uninstallScript | Set-Content -Path $uninstallBatPath -Encoding ASCII
    
    Write-Success "Startup configuration complete!"
}

function Unregister-Startup {
    Write-Header "LinkUp Studio Startup Removal"
    
    # Remove startup shortcut
    $startupShortcut = "$Config.StartupPath\LinkUp Studio.lnk"
    if (Test-Path $startupShortcut) {
        Remove-Item $startupShortcut -Force
        Write-Success "Removed startup shortcut"
    }
    
    # Update configuration
    $config = Get-StartupConfig
    $config.Enabled = $false
    $config.DisabledAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Save-StartupConfig -Config $config
    
    Write-Success "LinkUp Studio removed from Windows startup"
}

function Show-StartupStatus {
    Write-Header "LinkUp Studio Startup Status"
    
    $startupShortcut = "$Config.StartupPath\LinkUp Studio.lnk"
    $isEnabled = Test-Path $startupShortcut
    
    Write-Host ""
    if ($isEnabled) {
        Write-Host "  Status: ENABLED" -ForegroundColor Green
    } else {
        Write-Host "  Status: DISABLED" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "  Startup shortcut: $startupShortcut" -ForegroundColor Gray
    
    $config = Get-StartupConfig
    if ($config.Count -gt 0) {
        Write-Host ""
        Write-Host "  Configuration:" -ForegroundColor White
        if ($config.OpenHandsPath) {
            Write-Host "    OpenHands: $($config.OpenHandsPath)" -ForegroundColor Gray
        }
        if ($config.BrowserURL) {
            Write-Host "    Browser: $($config.BrowserURL)" -ForegroundColor Gray
        }
        if ($config.ProjectPath) {
            Write-Host "    Project: $($config.ProjectPath)" -ForegroundColor Gray
        }
        Write-Host "    Wait for services: $($config.WaitForServices)" -ForegroundColor Gray
        Write-Host "    Target startup time: $($config.MaxStartupTime) seconds" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "  Commands:" -ForegroundColor White
    Write-Host "    Enable:   .\Configure-Startup.ps1 -Enable" -ForegroundColor Gray
    Write-Host "    Disable:  .\Configure-Startup.ps1 -Disable" -ForegroundColor Gray
    Write-Host "    Status:   .\Configure-Startup.ps1 -Status" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Interactive Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

function Get-InteractiveConfig {
    $config = @{
        OpenHandsPath = ""
        BrowserURL = ""
        ProjectPath = ""
        WaitForServices = $true
    }
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " Configure LinkUp Studio Startup" -ForegroundColor White
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    
    # OpenHands Path
    Write-Host "Step 1: OpenHands Path" -ForegroundColor White
    Write-Host "  Press Enter to auto-detect, or enter custom path:" -ForegroundColor Gray
    Write-Host "  Example: C:\Program Files\OpenHands\openhands.exe" -ForegroundColor Gray
    $input = Read-Host "  OpenHands Path"
    if ($input) {
        $config.OpenHandsPath = $input.Trim()
    } else {
        # Auto-detect
        $paths = @(
            "$env:LOCALAPPDATA\Programs\open-hands\openhands.exe",
            "$env:LOCALAPPDATA\open-hands\openhands.exe",
            "$env:ProgramFiles\OpenHands\openhands.exe"
        )
        foreach ($path in $paths) {
            if (Test-Path $path) {
                $config.OpenHandsPath = $path
                Write-Host "  Detected: $path" -ForegroundColor Green
                break
            }
        }
    }
    
    Write-Host ""
    Write-Host "Step 2: Browser URL" -ForegroundColor White
    Write-Host "  Press Enter for default (OpenHands Cloud), or enter custom URL:" -ForegroundColor Gray
    $input = Read-Host "  Browser URL (default: https://app.all-hands.dev)"
    if ($input) {
        $config.BrowserURL = $input.Trim()
    } else {
        $config.BrowserURL = "https://app.all-hands.dev"
    }
    
    Write-Host ""
    Write-Host "Step 3: Project Path (Optional)" -ForegroundColor White
    Write-Host "  Enter the path to your project folder to restore on startup:" -ForegroundColor Gray
    Write-Host "  Press Enter to skip:" -ForegroundColor Gray
    $input = Read-Host "  Project Path"
    if ($input) {
        $projectPath = $input.Trim()
        if (Test-Path $projectPath) {
            $config.ProjectPath = $projectPath
        } else {
            Write-Warning "Path does not exist: $projectPath"
        }
    }
    
    Write-Host ""
    Write-Host "Step 4: Wait for Services" -ForegroundColor White
    Write-Host "  Should we wait for Windows Terminal to be ready before opening browser?" -ForegroundColor Gray
    $input = Read-Host "  Wait for services? (Y/n)"
    $config.WaitForServices = ($input -ne "n" -and $input -ne "N")
    
    return $config
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Entry Point
# ═══════════════════════════════════════════════════════════════════════════════════════

function Main {
    # Status check
    if ($Status) {
        Show-StartupStatus
        return
    }
    
    # Disable startup
    if ($Disable) {
        Unregister-Startup
        return
    }
    
    # Enable startup (with optional parameters)
    if ($Enable) {
        $config = Get-StartupConfig
        
        if ($OpenHandsPath -or $BrowserURL -or $ProjectPath -or $WaitForServices) {
            $config.OpenHandsPath = $OpenHandsPath
            $config.BrowserURL = $BrowserURL
            $config.ProjectPath = $ProjectPath
            $config.WaitForServices = $WaitForServices.IsPresent
        }
        
        Register-Startup `
            -OpenHandsPath $config.OpenHandsPath `
            -BrowserURL $config.BrowserURL `
            -ProjectPath $config.ProjectPath `
            -WaitForServices:$config.WaitForServices
        return
    }
    
    # Interactive configuration
    Write-Header "LinkUp Studio Startup Setup"
    
    Write-Host "This will configure Windows to launch LinkUp Studio automatically after login." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Startup sequence:" -ForegroundColor White
    Write-Host "  1. Launch Windows Terminal with LinkUp Studio" -ForegroundColor Cyan
    Write-Host "  2. Launch OpenHands" -ForegroundColor Cyan
    Write-Host "  3. Wait 500ms for services" -ForegroundColor Cyan
    Write-Host "  4. Open browser (OpenHands Cloud)" -ForegroundColor Cyan
    Write-Host "  5. Open previous project (if configured)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Target: < 10 seconds" -ForegroundColor Green
    Write-Host ""
    
    $confirm = Read-Host "Continue with setup? (Y/n)"
    if ($confirm -eq "n" -or $confirm -eq "N") {
        Write-Info "Setup cancelled"
        return
    }
    
    # Get interactive configuration
    $config = Get-InteractiveConfig
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host " Configuring startup..." -ForegroundColor White
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host ""
    
    # Register startup
    Register-Startup `
        -OpenHandsPath $config.OpenHandsPath `
        -BrowserURL $config.BrowserURL `
        -ProjectPath $config.ProjectPath `
        -WaitForServices:$config.WaitForServices
    
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host " Setup complete!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "LinkUp Studio will now launch automatically after Windows login." -ForegroundColor White
    Write-Host ""
    Write-Host "To disable: Run .\Configure-Startup.ps1 -Disable" -ForegroundColor Gray
    Write-Host ""
}

# Run main function
Main

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Startup Configuration v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════
