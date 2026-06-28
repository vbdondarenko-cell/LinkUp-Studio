# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Fast Startup Script v2.0
# Optimized for < 10 second startup time after Windows login
# ═══════════════════════════════════════════════════════════════════════════════════════
# This script runs automatically from Windows Startup folder
# Features: Parallel execution, GitHub integration, VS Code, Progress tracking
# ═══════════════════════════════════════════════════════════════════════════════════════

param(
    [string]$ConfigFile = "$env:LOCALAPPDATA\LinkUpStudio\startup_config.json",
    [switch]$Silent,
    [switch]$Debug
)

$ErrorActionPreference = "SilentlyContinue"
$StartTime = Get-Date

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration Defaults
# ═══════════════════════════════════════════════════════════════════════════════════════

$DefaultConfig = @{
    # URLs
    BrowserURL = "https://app.all-hands.dev"
    GitHubURL = "https://github.com"
    
    # Paths
    ProjectPath = ""
    VSCodePath = ""
    
    # Launch Options
    LaunchTerminal = $true
    LaunchOpenHands = $true
    LaunchBrowser = $true
    LaunchGitHub = $true
    LaunchVSCode = $true
    
    # Timing
    WaitForServices = $true
    LaunchDelay = 300
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Logging System
# ═══════════════════════════════════════════════════════════════════════════════════════

$LogDir = "$env:LOCALAPPDATA\LinkUpStudio"
if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

$LogFile = "$LogDir\startup_$(Get-Date -Format 'yyyyMMdd').log"
$ProgressLog = "$LogDir\startup_progress.txt"

function Write-Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss.fff"
    $logEntry = "$timestamp | [$Level] | $Message"
    
    if (-not $Silent) {
        $color = switch ($Level) {
            "SUCCESS" { "Green" }
            "ERROR" { "Red" }
            "WARNING" { "Yellow" }
            "DEBUG" { "Gray" }
            default { "Cyan" }
        }
        Write-Host "[$timestamp] $Message" -ForegroundColor $color
    }
    
    $logEntry | Add-Content -Path $LogFile -Encoding UTF8
    
    if ($Debug) {
        $logEntry | Add-Content -Path "$LogDir\startup_debug.log" -Encoding UTF8
    }
}

function Write-Progress {
    param([string]$Message)
    $Message | Add-Content -Path $ProgressLog -Encoding UTF8
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Initialize
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "═══════════════════════════════════════════════════════════════"
Write-Log "LinkUp Studio v2.0 - Developer Workspace Startup"
Write-Log "═══════════════════════════════════════════════════════════════"
Write-Progress "START"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Load Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = $DefaultConfig.Clone()

if (Test-Path $ConfigFile) {
    try {
        $LoadedConfig = Get-Content $ConfigFile -Raw | ConvertFrom-Json -AsHashtable
        foreach ($key in $LoadedConfig.Keys) {
            $Config[$key] = $LoadedConfig[$key]
        }
        Write-Log "Configuration loaded from: $ConfigFile" -Level "DEBUG"
    } catch {
        Write-Log "Failed to load config, using defaults" -Level "WARNING"
    }
}

Write-Log "Config: BrowserURL=$($Config.BrowserURL)" -Level "DEBUG"
Write-Log "Config: GitHubURL=$($Config.GitHubURL)" -Level "DEBUG"
Write-Log "Config: ProjectPath=$($Config.ProjectPath)" -Level "DEBUG"

# ═══════════════════════════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Get-OpenHandsPath {
    $paths = @(
        "$env:LOCALAPPDATA\Programs\open-hands\openhands.exe",
        "$env:LOCALAPPDATA\open-hands\openhands.exe",
        "$env:ProgramFiles\OpenHands\openhands.exe",
        "$env:ProgramFiles(x86)\OpenHands\openhands.exe",
        "$env:APPDATA\OpenHands\openhands.exe"
    )
    
    foreach ($path in $paths) {
        if (Test-Path $path) {
            return $path
        }
    }
    return $null
}

function Get-VSCodePath {
    $paths = @(
        "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
        "$env:ProgramFiles\Microsoft VS Code\Code.exe",
        "$env:ProgramFiles(x86)\Microsoft VS Code\Code.exe"
    )
    
    foreach ($path in $paths) {
        if (Test-Path $path) {
            return $path
        }
    }
    return $null
}

function Get-BrowserPath {
    # Try Edge first (faster on Windows)
    $edgePaths = @(
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    )
    
    foreach ($path in $edgePaths) {
        if (Test-Path $path) {
            return @{ Path = $path; Name = "Edge" }
        }
    }
    
    # Try Chrome
    $chromePaths = @(
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
    )
    
    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            return @{ Path = $path; Name = "Chrome" }
        }
    }
    
    return @{ Path = $null; Name = "Default" }
}

function Launch-Application {
    param(
        [string]$Path,
        [string]$Arguments = "",
        [string]$Name = "Application"
    )
    
    if (-not $Path) {
        Write-Log "$Name path not specified" -Level "DEBUG"
        return $false
    }
    
    if ($Path -ne "default" -and -not (Test-Path $Path)) {
        Write-Log "$Name not found at: $Path" -Level "WARNING"
        return $false
    }
    
    try {
        if ($Path -eq "default") {
            Start-Process -FilePath $Arguments -WindowStyle Normal
        } else {
            Start-Process -FilePath $Path -ArgumentList $Arguments -WindowStyle Normal
        }
        Write-Log "$Name launched successfully" -Level "SUCCESS"
        return $true
    } catch {
        Write-Log "Failed to launch $Name : $_" -Level "ERROR"
        return $false
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# PHASE 1: Parallel Launch (0-500ms)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "═══════════════════════════════════════════════════════════════"
Write-Log "PHASE 1: Parallel Application Launch"
Write-Log "═══════════════════════════════════════════════════════════════"
Write-Progress "PHASE1_START"

# Detect applications
$OpenHandsPath = Get-OpenHandsPath
$VSCodePath = Get-VSCodePath
$Browser = Get-BrowserPath

if ($OpenHandsPath) {
    Write-Log "OpenHands detected: $OpenHandsPath" -Level "DEBUG"
} else {
    Write-Log "OpenHands not found" -Level "WARNING"
}

if ($VSCodePath) {
    Write-Log "VS Code detected: $VSCodePath" -Level "DEBUG"
}

Write-Log "Browser detected: $($Browser.Name)" -Level "DEBUG"

# Launch Windows Terminal (always first)
Write-Log "Launching Windows Terminal..." -Level "DEBUG"
try {
    Start-Process -FilePath "wt.exe" -ArgumentList "-p `"Developer Dashboard`" --maximized" -WindowStyle Normal
    Write-Log "✓ Windows Terminal launched" -Level "SUCCESS"
} catch {
    Write-Log "✗ Failed to launch Windows Terminal" -Level "ERROR"
}

# Launch OpenHands (if enabled and found)
if ($Config.LaunchOpenHands -and $OpenHandsPath) {
    Write-Log "Launching OpenHands..." -Level "DEBUG"
    try {
        Start-Process -FilePath $OpenHandsPath -WindowStyle Normal
        Write-Log "✓ OpenHands launched" -Level "SUCCESS"
        Write-Progress "OPENHANDS"
    } catch {
        Write-Log "✗ Failed to launch OpenHands" -Level "ERROR"
    }
} elseif ($Config.LaunchOpenHands) {
    Write-Log "OpenHands enabled but not found, skipping" -Level "WARNING"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# PHASE 2: Wait for Services
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "Waiting for services to stabilize..." -Level "DEBUG"
$waitTime = if ($Config.WaitForServices) { $Config.LaunchDelay } else { 200 }
Start-Sleep -Milliseconds $waitTime
Write-Log "Services ready" -Level "DEBUG"
Write-Progress "SERVICES_READY"

# ═══════════════════════════════════════════════════════════════════════════════════════
# PHASE 3: Browser & GitHub (700ms)
# ═══════════════════════════════════════════════════════════════════════════════════════

Write-Log "═══════════════════════════════════════════════════════════════"
Write-Log "PHASE 3: Browser Applications"
Write-Log "═══════════════════════════════════════════════════════════════"
Write-Progress "PHASE3_START"

# Launch OpenHands in browser
if ($Config.LaunchBrowser) {
    $browserArgs = "--new-window"
    
    if ($Browser.Name -eq "Edge") {
        $browserArgs += " --start-fullscreen"
    } elseif ($Browser.Name -eq "Chrome") {
        $browserArgs += " --start-maximized"
    }
    
    $browserArgs += " `"$($Config.BrowserURL)`""
    
    Write-Log "Launching $($Browser.Name) with OpenHands..." -Level "DEBUG"
    try {
        if ($Browser.Path) {
            Start-Process -FilePath $Browser.Path -ArgumentList ($browserArgs -replace '\"', '"') -WindowStyle Normal
        } else {
            Start-Process -FilePath $Config.BrowserURL -WindowStyle Normal
        }
        Write-Log "✓ OpenHands (Browser) launched" -Level "SUCCESS"
        Write-Progress "BROWSER_OPENHANDS"
    } catch {
        Write-Log "✗ Failed to launch browser" -Level "ERROR"
    }
}

# Launch GitHub
if ($Config.LaunchGitHub) {
    Start-Sleep -Milliseconds 500
    Write-Log "Launching GitHub..." -Level "DEBUG"
    try {
        if ($Browser.Path -and $Browser.Name -ne "Default") {
            Start-Process -FilePath $Browser.Path -ArgumentList "--new-tab", $Config.GitHubURL -WindowStyle Normal
        } else {
            Start-Process -FilePath $Config.GitHubURL -WindowStyle Normal
        }
        Write-Log "✓ GitHub launched" -Level "SUCCESS"
        Write-Progress "BROWSER_GITHUB"
    } catch {
        Write-Log "✗ Failed to launch GitHub" -Level "ERROR"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# PHASE 4: VS Code & Project
# ═══════════════════════════════════════════════════════════════════════════════════════

if ($Config.LaunchVSCode -and $VSCodePath -and $Config.ProjectPath) {
    Write-Log "═══════════════════════════════════════════════════════════════"
    Write-Log "PHASE 4: VS Code & Project"
    Write-Log "═══════════════════════════════════════════════════════════════"
    Write-Progress "PHASE4_START"
    
    Start-Sleep -Milliseconds 300
    
    try {
        if (Test-Path $Config.ProjectPath) {
            Start-Process -FilePath $VSCodePath -ArgumentList "`"$($Config.ProjectPath)`"" -WindowStyle Normal
            Write-Log "✓ VS Code launched with project: $($Config.ProjectPath)" -Level "SUCCESS"
            Write-Progress "VSCODE_PROJECT"
        } else {
            Start-Process -FilePath $VSCodePath -WindowStyle Normal
            Write-Log "✓ VS Code launched (no project)" -Level "SUCCESS"
            Write-Progress "VSCODE"
        }
    } catch {
        Write-Log "✗ Failed to launch VS Code" -Level "ERROR"
    }
} elseif ($Config.LaunchVSCode -and $VSCodePath) {
    Start-Process -FilePath $VSCodePath -WindowStyle Normal
    Write-Log "✓ VS Code launched" -Level "SUCCESS"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# PHASE 5: Open Project in Terminal
# ═══════════════════════════════════════════════════════════════════════════════════════

if ($Config.ProjectPath -and (Test-Path $Config.ProjectPath)) {
    Write-Log "Opening project in Terminal..." -Level "DEBUG"
    try {
        Start-Process -FilePath "wt.exe" -ArgumentList "new-tab; cd `"$($Config.ProjectPath)`"" -WindowStyle Normal
        Write-Log "✓ Project opened in new terminal tab" -Level "SUCCESS"
        Write-Progress "TERMINAL_PROJECT"
    } catch {
        Write-Log "✗ Failed to open project in terminal" -Level "ERROR"
    }
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Finalize
# ═══════════════════════════════════════════════════════════════════════════════════════

$EndTime = Get-Date
$Elapsed = ($EndTime - $StartTime).TotalSeconds

Write-Log "═══════════════════════════════════════════════════════════════"
Write-Log "STARTUP COMPLETE"
Write-Log "═══════════════════════════════════════════════════════════════"
Write-Log "Total time: $([math]::Round($Elapsed, 2)) seconds" -Level "SUCCESS"
Write-Progress "COMPLETE:$Elapsed"

if ($Elapsed -le 10) {
    Write-Log "✓ Target achieved: < 10 seconds" -Level "SUCCESS"
} else {
    Write-Log "⚠ Target missed: > 10 seconds" -Level "WARNING"
}

Write-Log "═══════════════════════════════════════════════════════════════"

# Clean up progress file after delay
Start-Sleep -Seconds 5
if (Test-Path $ProgressLog) {
    Remove-Item $ProgressLog -Force -ErrorAction SilentlyContinue
}

# Exit cleanly
exit 0

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio Fast Startup v2.0
# Features: Parallel execution, GitHub integration, VS Code, Progress tracking
# ═══════════════════════════════════════════════════════════════════════════════════════
