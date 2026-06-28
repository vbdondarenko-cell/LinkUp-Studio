# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Fast Startup Script
# Optimized for < 10 second startup time after Windows login
# ═══════════════════════════════════════════════════════════════════════════════════════
# This script runs automatically from Windows Startup folder
# Do not run manually - it will close immediately

param(
    [string]$ConfigFile = "$env:LOCALAPPDATA\LinkUpStudio\startup_config.json"
)

$ErrorActionPreference = "SilentlyContinue"
$StartTime = Get-Date

# ═══════════════════════════════════════════════════════════════════════════════════════
# Logging
# ═══════════════════════════════════════════════════════════════════════════════════════

$LogDir = "$env:LOCALAPPDATA\LinkUpStudio"
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$LogFile = "$LogDir\startup.log"

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "HH:mm:ss.fff"
    "$timestamp | $Message" | Add-Content -Path $LogFile -Encoding UTF8
}

Write-Log "=== LinkUp Studio Startup Initiated ==="

# ═══════════════════════════════════════════════════════════════════════════════════════
# Load Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = @{
    BrowserURL = "https://app.all-hands.dev"
    ProjectPath = ""
    WaitForServices = $true
}

if (Test-Path $ConfigFile) {
    try {
        $LoadedConfig = Get-Content $ConfigFile -Raw | ConvertFrom-Json -AsHashtable
        foreach ($key in $LoadedConfig.Keys) {
            $Config[$key] = $LoadedConfig[$key]
        }
        Write-Log "Configuration loaded from: $ConfigFile"
    } catch {
        Write-Log "Failed to load config, using defaults"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# OpenHands Detection
# ═══════════════════════════════════════════════════════════════════════════════════════

$OpenHandsPath = $Config.OpenHandsPath

if (-not $OpenHandsPath) {
    $OpenHandsPaths = @(
        "$env:LOCALAPPDATA\Programs\open-hands\openhands.exe",
        "$env:LOCALAPPDATA\open-hands\openhands.exe",
        "$env:ProgramFiles\OpenHands\openhands.exe",
        "$env:APPDATA\OpenHands\openhands.exe"
    )
    
    foreach ($path in $OpenHandsPaths) {
        if (Test-Path $path) {
            $OpenHandsPath = $path
            Write-Log "OpenHands detected: $path"
            break
        }
    }
}

if (-not $OpenHandsPath) {
    Write-Log "OpenHands not found, will try executable name"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Stage 1: Launch Windows Terminal (Immediate - 0ms)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "STAGE 1: Launching Windows Terminal"

try {
    Start-Process -FilePath "wt.exe" -ArgumentList "-p `"Developer Dashboard`" --maximized" -WindowStyle Normal -PassThru | Out-Null
    Write-Log "Windows Terminal launched"
} catch {
    Write-Log "Failed to launch Windows Terminal: $_"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Stage 2: Launch OpenHands (Parallel - 0ms)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "STAGE 2: Launching OpenHands"

if ($OpenHandsPath) {
    try {
        Start-Process -FilePath $OpenHandsPath -WindowStyle Normal -PassThru | Out-Null
        Write-Log "OpenHands launched: $OpenHandsPath"
    } catch {
        Write-Log "Failed to launch OpenHands: $_"
    }
} else {
    # Try executable names
    try {
        Start-Process -FilePath "openhands.exe" -WindowStyle Normal -PassThru | Out-Null
        Write-Log "OpenHands launched (by name)"
    } catch {
        try {
            Start-Process -FilePath "openhands-app.exe" -WindowStyle Normal -PassThru | Out-Null
            Write-Log "OpenHands launched (openhands-app)"
        } catch {
            Write-Log "Could not launch OpenHands"
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Stage 3: Wait for Services (Conditional - 500ms)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "STAGE 3: Service stabilization delay"

if ($Config.WaitForServices) {
    Start-Sleep -Milliseconds 500
    Write-Log "Services wait complete (500ms)"
} else {
    Start-Sleep -Milliseconds 200
    Write-Log "Minimal delay complete (200ms)"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Stage 4: Launch Browser (500ms after start)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "STAGE 4: Launching browser"

$BrowserURL = $Config.BrowserURL
if (-not $BrowserURL) {
    $BrowserURL = "https://app.all-hands.dev"
}

try {
    # Try Edge first (faster on Windows)
    $EdgePath = "msedge.exe"
    $EdgePaths = @(
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    )
    
    $launched = $false
    foreach ($path in $EdgePaths) {
        if (Test-Path $path) {
            Start-Process -FilePath $path -ArgumentList "--new-window", "--start-fullscreen", $BrowserURL -WindowStyle Normal -PassThru | Out-Null
            Write-Log "Browser launched (Edge): $BrowserURL"
            $launched = $true
            break
        }
    }
    
    if (-not $launched) {
        # Fallback to default browser
        Start-Process -FilePath $BrowserURL -WindowStyle Normal -PassThru | Out-Null
        Write-Log "Browser launched (default): $BrowserURL"
    }
} catch {
    Write-Log "Failed to launch browser: $_"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Stage 5: Restore Project (700ms after start, if configured)
# ═══════════════════════════════════════════════════════════════════════════════════════

if ($Config.ProjectPath -and (Test-Path $Config.ProjectPath)) {
    Write-Log "STAGE 5: Opening project"
    
    Start-Sleep -Milliseconds 200
    
    try {
        # Open in Windows Terminal
        Start-Process -FilePath "wt.exe" -ArgumentList "new-tab; cd `"$($Config.ProjectPath)`"" -WindowStyle Normal -PassThru | Out-Null
        Write-Log "Project opened: $($Config.ProjectPath)"
    } catch {
        Write-Log "Failed to open project: $_"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Calculate Total Startup Time
# ═══════════════════════════════════════════════════════════════════════════════════════

$EndTime = Get-Date
$Elapsed = ($EndTime - $StartTime).TotalSeconds

Write-Log "=== Startup Complete: $([math]::Round($Elapsed, 2)) seconds ==="

if ($Elapsed -le 10) {
    Write-Log "SUCCESS: Startup time within target (< 10s)"
} else {
    Write-Log "WARNING: Startup exceeded target (10s)"
}

# Exit cleanly (no window remains)
exit 0

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Fast Startup v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════
