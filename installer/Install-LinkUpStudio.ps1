# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio One-Click Installer
# Premium Developer Environment - Complete Setup
# ═══════════════════════════════════════════════════════════════════════════════════════
#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [switch]$Uninstall,
    [switch]$SkipFonts,
    [switch]$SkipIcons,
    [switch]$SkipCursors,
    [switch]$SkipTerminal,
    [switch]$SkipVSCode,
    [switch]$SkipShortcuts,
    [switch]$SkipBackup,
    [switch]$Silent,
    [switch]$Verbose
)

$ErrorActionPreference = if ($Verbose) { "Continue" } else { "Stop" }

# ═══════════════════════════════════════════════════════════════════════════════════════
# Configuration
# ═══════════════════════════════════════════════════════════════════════════════════════

$Config = @{
    AppName = "LinkUp Studio"
    Version = "1.0.0"
    RepoURL = "https://github.com/vbdondarenko-cell/LinkUp-Studio"
    InstallDir = "$env:LOCALAPPDATA\LinkUpStudio"
    BackupDir = "$env:LOCALAPPDATA\LinkUpStudio\Backups"
    LogFile = "$env:TEMP\LinkUpStudio_Install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
    RegistryPath = "HKCU:\Software\LinkUpStudio"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Helper Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Write-Header {
    param([string]$Title)
    $width = 80
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
    Log-Message "[STEP] $Message"
}

function Write-Success {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[✓] $Message" -ForegroundColor Green
    }
    Log-Message "[SUCCESS] $Message"
}

function Write-Warning {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[!] $Message" -ForegroundColor Yellow
    }
    Log-Message "[WARNING] $Message"
}

function Write-Error {
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor Red
    Log-Message "[ERROR] $Message"
}

function Write-Info {
    param([string]$Message)
    if (-not $Silent) {
        Write-Host "[i] $Message" -ForegroundColor Gray
    }
    Log-Message "[INFO] $Message"
}

function Log-Message {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $Message" | Add-Content -Path $Config.LogFile -Encoding UTF8
}

function Test-Administrator {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Get-InstallerPath {
    return Split-Path -Parent $MyInvocation.MyCommand.Path
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Backup Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Backup-ExistingSettings {
    Write-Step "Creating backup of existing settings..."
    
    $backupTimestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupPath = Join-Path $Config.BackupDir $backupTimestamp
    
    if (-not (Test-Path $backupPath)) {
        New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
    }
    
    $backedUp = @()
    
    # Backup PowerShell Profile
    $profilePath = $PROFILE
    if (Test-Path $profilePath) {
        $content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($content -match "LinkUp Studio") {
            $backupFile = Join-Path $backupPath "PowerShell_profile.backup.ps1"
            Copy-Item $profilePath $backupFile -Force
            $backedUp += "PowerShell Profile"
            Write-Info "Backed up: PowerShell Profile"
        }
    }
    
    # Backup Windows Terminal Settings
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $wtSettingsPath) {
        $content = Get-Content $wtSettingsPath -Raw -ErrorAction SilentlyContinue
        if ($content -match "linkup" -or $content -match "LinkUp") {
            $backupFile = Join-Path $backupPath "WindowsTerminal_settings.backup.json"
            Copy-Item $wtSettingsPath $backupFile -Force
            $backedUp += "Windows Terminal Settings"
            Write-Info "Backed up: Windows Terminal Settings"
        }
    }
    
    # Backup Cursor Registry
    $cursorPath = "HKCU:\Control Panel\Cursors"
    if (Test-Path $cursorPath) {
        $backupFile = Join-Path $backupPath "CursorRegistry.backup.reg"
        $regContent = @()
        Get-ItemProperty -Path $cursorPath -ErrorAction SilentlyContinue | ForEach-Object {
            $regContent += "Windows Registry Editor Version 5.00`n"
            $regContent += "`n[HKEY_CURRENT_USER\Control Panel\Cursors]`n"
            $_.PSObject.Properties | Where-Object { $_.Name -notmatch "^PS" } | ForEach-Object {
                $regContent += "`"$($_.Name)`"=`"$($_.Value)`"`n"
            }
        }
        $regContent | Set-Content -Path $backupFile -Encoding UTF8
        $backedUp += "Cursor Registry"
        Write-Info "Backed up: Cursor Registry"
    }
    
    # Backup VS Code Settings
    $vscodePath = "$env:APPDATA\Code\User\settings.json"
    if (Test-Path $vscodePath) {
        $content = Get-Content $vscodePath -Raw -ErrorAction SilentlyContinue
        if ($content -match "workbench.colorTheme" -and $content -match "LinkUp") {
            $backupFile = Join-Path $backupPath "VSCode_settings.backup.json"
            Copy-Item $vscodePath $backupFile -Force
            $backedUp += "VS Code Settings"
            Write-Info "Backed up: VS Code Settings"
        }
    }
    
    # Backup Windows Theme
    $themeBackupPath = "$env:LOCALAPPDATA\Microsoft\Windows\Themes\Backup"
    if (-not (Test-Path $themeBackupPath)) {
        New-Item -ItemType Directory -Path $themeBackupPath -Force | Out-Null
    }
    
    if ($backedUp.Count -gt 0) {
        Write-Success "Backed up $($backedUp.Count) item(s) to: $backupPath"
        
        # Create backup manifest
        $manifest = @{
            Timestamp = $backupTimestamp
            BackedUpItems = $backedUp
            RestorePath = $backupPath
        } | ConvertTo-Json -Depth 3
        $manifest | Set-Content -Path (Join-Path $backupPath "manifest.json") -Encoding UTF8
    } else {
        Write-Info "No existing LinkUp Studio settings found to backup"
    }
    
    return $backupPath
}

function Restore-Backup {
    param([string]$BackupPath)
    
    Write-Step "Restoring backup from: $BackupPath"
    
    if (-not (Test-Path $BackupPath)) {
        Write-Error "Backup path not found: $BackupPath"
        return $false
    }
    
    $restored = @()
    
    # Restore PowerShell Profile
    $profileBackup = Join-Path $BackupPath "PowerShell_profile.backup.ps1"
    if (Test-Path $profileBackup) {
        $profilePath = $PROFILE
        Copy-Item $profileBackup $profilePath -Force
        $restored += "PowerShell Profile"
    }
    
    # Restore Windows Terminal Settings
    $wtBackup = Join-Path $BackupPath "WindowsTerminal_settings.backup.json"
    if (Test-Path $wtBackup) {
        $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Copy-Item $wtBackup $wtSettingsPath -Force
        $restored += "Windows Terminal Settings"
    }
    
    # Restore Cursor Registry
    $cursorBackup = Join-Path $BackupPath "CursorRegistry.backup.reg"
    if (Test-Path $cursorBackup) {
        $cursorPath = "HKCU:\Control Panel\Cursors"
        $regContent = Get-Content $cursorBackup -Raw
        $regContent | ForEach-Object { 
            $lines = ($_ -split "`n").Trim()
            $cursorValues = @{}
            foreach ($line in $lines) {
                if ($line -match '"(.+)"="(.+)"') {
                    $cursorValues[$matches[1]] = $matches[2]
                }
            }
            if ($cursorValues.Count -gt 0) {
                Set-ItemProperty -Path $cursorPath -Name "(Default)" -Value "" -ErrorAction SilentlyContinue
                foreach ($key in $cursorValues.Keys) {
                    Set-ItemProperty -Path $cursorPath -Name $key -Value $cursorValues[$key] -ErrorAction SilentlyContinue
                }
            }
        }
        $restored += "Cursor Registry"
    }
    
    # Restore VS Code Settings
    $vscodeBackup = Join-Path $BackupPath "VSCode_settings.backup.json"
    if (Test-Path $vscodeBackup) {
        $vscodePath = "$env:APPDATA\Code\User\settings.json"
        Copy-Item $vscodeBackup $vscodePath -Force
        $restored += "VS Code Settings"
    }
    
    if ($restored.Count -gt 0) {
        Write-Success "Restored $($restored.Count) item(s)"
        return $true
    }
    
    Write-Warning "No items found to restore"
    return $false
}

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
                    Items = $manifest.BackedUpItems
                }
            } else {
                $backups += @{
                    Timestamp = $_.Name
                    Path = $_.FullName
                    Items = @("Unknown")
                }
            }
        }
    }
    return $backups
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Installation Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-Fonts {
    if ($SkipFonts) {
        Write-Info "Skipping fonts installation"
        return
    }
    
    Write-Step "Installing fonts..."
    
    $installerPath = Get-InstallerPath
    $fontsSource = Join-Path $installerPath "..\fonts"
    
    # Check if fonts directory exists locally
    $localFontsSource = Join-Path $installerPath "..\icons"
    if (-not (Test-Path $localFontsSource)) {
        Write-Info "Font source not found locally, skipping font installation"
        return
    }
    
    $fontsInstalled = @()
    
    # Install JetBrains Mono (if available in icons folder)
    $fontsDir = [Environment]::GetFolderPath("Fonts")
    
    # For now, we'll provide instructions since fonts need to be downloaded
    Write-Info "To install JetBrains Mono font:"
    Write-Info "  1. Download from: https://www.jetbrains.com/lp/mono/"
    Write-Info "  2. Extract and install all .ttf files"
    Write-Info "  3. Or run: winget install JetBrains.JetBrainsMono"
    
    Write-Success "Font installation instructions provided"
}

function Install-IconPack {
    if ($SkipIcons) {
        Write-Info "Skipping icon pack installation"
        return
    }
    
    Write-Step "Installing icon pack..."
    
    $installerPath = Get-InstallerPath
    $iconsSource = Join-Path $installerPath "..\icons"
    
    if (-not (Test-Path $iconsSource)) {
        Write-Warning "Icon source not found: $iconsSource"
        return
    }
    
    # Create icons backup directory
    $iconsBackupDir = Join-Path $Config.InstallDir "icons_backup"
    
    # Install folder icons
    $shellFolders = @(
        @{ Path = "$env:USERPROFILE\Desktop"; Name = "Desktop" },
        @{ Path = "$env:USERPROFILE\Documents"; Name = "Documents" },
        @{ Path = "$env:USERPROFILE\Downloads"; Name = "Downloads" },
        @{ Path = "$env:USERPROFILE\Music"; Name = "Music" },
        @{ Path = "$env:USERPROFILE\Pictures"; Name = "Pictures" },
        @{ Path = "$env:USERPROFILE\Videos"; Name = "Videos" }
    )
    
    $iconsDir = Join-Path $iconsSource "ico"
    
    foreach ($folder in $shellFolders) {
        $iconName = "folder-$($folder.Name.ToLower()).ico"
        $iconPath = Join-Path $iconsDir $iconName
        
        if (Test-Path $iconPath) {
            Write-Info "Icon for $($folder.Name): Available at $iconPath"
            Write-Info "  To apply: Right-click folder → Properties → Customize → Change Icon"
        }
    }
    
    # Store icon installation info for later use
    $iconConfig = @{
        SourcePath = $iconsDir
        Installed = $true
        InstalledAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    }
    
    if (-not (Test-Path $Config.InstallDir)) {
        New-Item -ItemType Directory -Path $Config.InstallDir -Force | Out-Null
    }
    
    $iconConfig | ConvertTo-Json -Depth 3 | Set-Content -Path (Join-Path $Config.InstallDir "icons_config.json") -Encoding UTF8
    
    Write-Success "Icon pack installation prepared"
    Write-Info "Icons are available in the installer directory"
    Write-Info "Apply manually: Right-click folder → Properties → Customize → Change Icon"
}

function Install-CustomCursors {
    if ($SkipCursors) {
        Write-Info "Skipping cursor installation"
        return
    }
    
    Write-Step "Installing custom cursors..."
    
    $installerPath = Get-InstallerPath
    $cursorsSource = Join-Path $installerPath "..\cursors\cur"
    
    if (-not (Test-Path $cursorsSource)) {
        Write-Warning "Cursor source not found: $cursorsSource"
        return
    }
    
    $cursorPath = "HKCU:\Control Panel\Cursors"
    
    # Create cursors directory
    $cursorsDir = Join-Path $Config.InstallDir "cursors"
    if (-not (Test-Path $cursorsDir)) {
        New-Item -ItemType Directory -Path $cursorsDir -Force | Out-Null
    }
    
    # Copy cursor files
    Copy-Item "$cursorsSource\*" $cursorsDir -Force
    
    # Map cursor types
    $cursorMap = @{
        "Arrow" = "normal.cur"
        "Help" = "hand.cur"
        "AppStarting" = "loading.cur"
        "Wait" = "busy.cur"
        "Crosshair" = "precision.cur"
        "IBeam" = "text.cur"
        "No" = "link.cur"
        "Hand" = "hand.cur"
        "SizeAll" = "move.cur"
        "SizeNESW" = "resize-diagonal.cur"
        "SizeNS" = "resize-vertical.cur"
        "SizeNWSE" = "resize-diagonal.cur"
        "SizeWE" = "resize-horizontal.cur"
        "UpArrow" = "precision.cur"
        "Pin" = "link.cur"
        "Person" = "link.cur"
    }
    
    # Apply cursor registry settings
    $cursorsConfig = @{}
    
    foreach ($cursorType in $cursorMap.Keys) {
        $cursorFile = $cursorMap[$cursorType]
        $cursorFullPath = Join-Path $cursorsDir $cursorFile
        if (Test-Path $cursorFullPath) {
            Set-ItemProperty -Path $cursorPath -Name $cursorType -Value $cursorFullPath -ErrorAction SilentlyContinue
            $cursorsConfig[$cursorType] = $cursorFile
        }
    }
    
    # Save cursors config
    $cursorsConfig | ConvertTo-Json -Depth 3 | Set-Content -Path (Join-Path $Config.InstallDir "cursors_config.json") -Encoding UTF8
    
    Write-Success "Custom cursors installed to: $cursorsDir"
    Write-Info "Cursors have been applied to your system"
}

function Install-WindowsTerminal {
    if ($SkipTerminal) {
        Write-Info "Skipping Windows Terminal configuration"
        return
    }
    
    Write-Step "Configuring Windows Terminal..."
    
    $installerPath = Get-InstallerPath
    $wtSource = Join-Path $installerPath "..\windows-terminal"
    
    if (-not (Test-Path $wtSource)) {
        Write-Warning "Windows Terminal source not found: $wtSource"
        return
    }
    
    # Install Oh My Posh
    Write-Step "Checking Oh My Posh..."
    $omp = Get-Command oh-my-posh -ErrorAction SilentlyContinue
    if (-not $omp) {
        Write-Info "Installing Oh My Posh..."
        try {
            winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements -h 2>&1 | Out-Null
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
            Write-Success "Oh My Posh installed"
        } catch {
            Write-Warning "Could not install Oh My Posh automatically"
            Write-Info "Please install manually: winget install JanDeDobbeleer.OhMyPosh"
        }
    } else {
        Write-Info "Oh My Posh is already installed"
    }
    
    # Backup existing Windows Terminal settings
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $wtSettingsPath) {
        $backupFile = "$wtSettingsPath.linkup.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $wtSettingsPath $backupFile -Force
        Write-Info "Backed up existing Windows Terminal settings"
    }
    
    # Copy Windows Terminal settings
    Write-Step "Installing Windows Terminal settings..."
    $wtSettings = Get-Content (Join-Path $wtSource "settings.json") -Raw
    Set-Content -Path $wtSettingsPath -Value $wtSettings -Force -Encoding UTF8
    Write-Success "Windows Terminal settings installed"
    
    # Install Oh My Posh theme
    Write-Step "Installing Oh My Posh theme..."
    $ompPath = $env:POSH_THEMES_PATH
    if ($ompPath) {
        Copy-Item (Join-Path $wtSource "linkup.omp.json") $ompPath -Force
        Write-Success "Oh My Posh theme installed"
    } else {
        Write-Warning "Oh My Posh themes path not found"
    }
    
    # Install PowerShell Profile
    Write-Step "Installing PowerShell profile..."
    $profilePath = $PROFILE
    $profileDir = Split-Path -Parent $profilePath
    
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    if (Test-Path $profilePath) {
        $existingContent = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($existingContent -match "LinkUp Studio") {
            Write-Info "LinkUp Studio profile already installed"
        } else {
            # Backup original
            Copy-Item $profilePath "$profilePath.linkup.backup" -Force
            
            # Create wrapper that includes LinkUp Studio
            $wrapperContent = @"
# LinkUp Studio - Wrapper Profile
# This file loads the LinkUp Studio profile

# Load LinkUp Studio profile
. '$wtSource\Microsoft.PowerShell_profile.ps1'
"@
            $wrapperContent | Set-Content -Path $profilePath -Force -Encoding UTF8
            Copy-Item (Join-Path $wtSource "Microsoft.PowerShell_profile.ps1") (Join-Path $profileDir "LinkUpStudio_profile.ps1") -Force
            Write-Success "PowerShell profile configured"
        }
    } else {
        Copy-Item (Join-Path $wtSource "Microsoft.PowerShell_profile.ps1") $profilePath -Force
        Write-Success "PowerShell profile created"
    }
}

function Install-VSCodeSettings {
    if ($SkipVSCode) {
        Write-Info "Skipping VS Code configuration"
        return
    }
    
    Write-Step "Configuring Visual Studio Code..."
    
    $vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
    $vscodeDir = Split-Path -Parent $vscodeSettingsPath
    
    if (-not (Test-Path $vscodeDir)) {
        New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null
    }
    
    # Create VS Code settings
    $vscodeSettings = @{
        "workbench.colorTheme" = "GitHub Dark Default"
        "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', Consolas, 'Courier New', monospace"
        "editor.fontSize" = 14
        "editor.fontLigatures" = $true
        "editor.lineHeight" = 1.6
        "editor.letterSpacing" = 0.5
        "editor.cursorStyle" = "line"
        "editor.cursorWidth" = 2
        "editor.cursorBlinking" = "phase"
        "editor.renderWhitespace" = "boundary"
        "editor.minimap.enabled" = $true
        "editor.minimap.maxColumn" = 120
        "editor.rulers" = @(80, 120)
        "editor.wordWrap" = "off"
        "editor.formatOnSave" = $true
        "editor.tabSize" = 2
        "editor.insertSpaces" = $true
        "terminal.integrated.fontFamily" = "'JetBrains Mono', 'Fira Code', Consolas"
        "terminal.integrated.fontSize" = 13
        "terminal.integrated.cursorStyle" = "line"
        "terminal.integrated.cursorWidth" = 2
        "terminal.integrated.cursorBlinking" = "phase"
        "terminal.integrated.shell.windows" = "C:\Program Files\PowerShell\7\pwsh.exe"
        "window.titleBarStyle" = "custom"
        "window.frame" = $true
        "window.newWindowDimensions" = "inherit"
        "files.autoSave" = "afterDelay"
        "files.autoSaveDelay" = 1000
        "files.trimTrailingWhitespace" = $true
        "files.insertFinalNewline" = $true
        "git.autofetch" = $true
        "git.confirmSync" = $false
        "git.enableSmartCommit" = $true
        "scm.defaultViewMode" = "tree"
        "explorer.confirmDelete" = $false
        "extensions.autoUpdate" = $true
    } | ConvertTo-Json -Depth 3
    
    # Backup existing settings
    if (Test-Path $vscodeSettingsPath) {
        $backupFile = "$vscodeSettingsPath.linkup.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $vscodeSettingsPath $backupFile -Force
        Write-Info "Backed up existing VS Code settings"
    }
    
    # Merge with existing settings
    if (Test-Path $vscodeSettingsPath) {
        try {
            $existingSettings = Get-Content $vscodeSettingsPath -Raw | ConvertFrom-Json -AsHashtable
            $newSettings = $vscodeSettings | ConvertFrom-Json -AsHashtable
            foreach ($key in $newSettings.Keys) {
                $existingSettings[$key] = $newSettings[$key]
            }
            $mergedSettings = $existingSettings | ConvertTo-Json -Depth 3
            Set-Content -Path $vscodeSettingsPath -Value $mergedSettings -Force -Encoding UTF8
        } catch {
            Set-Content -Path $vscodeSettingsPath -Value $vscodeSettings -Force -Encoding UTF8
        }
    } else {
        Set-Content -Path $vscodeSettingsPath -Value $vscodeSettings -Force -Encoding UTF8
    }
    
    Write-Success "VS Code settings configured"
    
    # Install recommended extensions
    Write-Step "Checking recommended VS Code extensions..."
    $extensions = @(
        "GitHub.github-vscode-theme",
        "ms-vscode.powershell",
        "esbenp.prettier-vscode",
        "dbaeumer.vscode-eslint",
        "editorconfig.editorconfig"
    )
    
    foreach ($ext in $extensions) {
        code --install-extension $ext --force 2>&1 | Out-Null
    }
    
    Write-Success "VS Code extensions installation requested"
}

function New-DesktopShortcut {
    Write-Step "Creating desktop shortcut..."
    
    $desktop = [Environment]::GetFolderPath("Desktop")
    $shortcutPath = Join-Path $desktop "LinkUp Studio.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "wt.exe"
    $Shortcut.Arguments = "-p `"Developer Dashboard`""
    $Shortcut.Description = "LinkUp Studio - Premium Developer Environment"
    $Shortcut.WorkingDirectory = $env:USERPROFILE
    
    # Try to set custom icon
    $installerPath = Get-InstallerPath
    $iconPath = Join-Path $installerPath "..\icons\ico\desktop.ico"
    if (Test-Path $iconPath) {
        $Shortcut.IconLocation = $iconPath
    }
    
    $Shortcut.Save()
    
    Write-Success "Desktop shortcut created: $shortcutPath"
}

function New-StartMenuShortcut {
    Write-Step "Creating Start Menu shortcut..."
    
    $startMenu = [Environment]::GetFolderPath("StartMenu")
    $programsPath = Join-Path $startMenu "Programs"
    $shortcutDir = Join-Path $programsPath "LinkUp Studio"
    
    if (-not (Test-Path $shortcutDir)) {
        New-Item -ItemType Directory -Path $shortcutDir -Force | Out-Null
    }
    
    $shortcutPath = Join-Path $shortcutDir "LinkUp Studio.lnk"
    
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.TargetPath = "wt.exe"
    $Shortcut.Arguments = "-p `"Developer Dashboard`""
    $Shortcut.Description = "LinkUp Studio - Premium Developer Environment"
    $Shortcut.WorkingDirectory = $env:USERPROFILE
    
    $installerPath = Get-InstallerPath
    $iconPath = Join-Path $installerPath "..\icons\ico\desktop.ico"
    if (Test-Path $iconPath) {
        $Shortcut.IconLocation = $iconPath
    }
    
    $Shortcut.Save()
    
    # Create uninstall shortcut
    $uninstallPath = Join-Path $shortcutDir "Uninstall.lnk"
    $uninstallShortcut = $WshShell.CreateShortcut($uninstallPath)
    $uninstallShortcut.TargetPath = "powershell.exe"
    $uninstallShortcut.Arguments = "-ExecutionPolicy Bypass -File `"$installerPath\Install-LinkUpStudio.ps1`" -Uninstall"
    $uninstallShortcut.Description = "Uninstall LinkUp Studio"
    $uninstallShortcut.WorkingDirectory = $installerPath
    $uninstallShortcut.Save()
    
    Write-Success "Start Menu shortcuts created"
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Uninstallation Functions
# ═══════════════════════════════════════════════════════════════════════════════════════

function Uninstall-LinkUpStudio {
    Write-Header "LinkUp Studio Uninstaller"
    
    Write-Host "This will remove all LinkUp Studio configurations." -ForegroundColor Yellow
    Write-Host ""
    
    # List available backups
    $backups = Get-AvailableBackups
    if ($backups.Count -gt 0) {
        Write-Host "Available backups:" -ForegroundColor White
        foreach ($i in 0..($backups.Count - 1)) {
            Write-Host "  [$i] $($backups[$i].Timestamp) - $($backups[$i].Items -join ', ')"
        }
        Write-Host ""
        
        $restoreChoice = Read-Host "Restore from backup before uninstall? (Enter backup number or 'N' to skip)"
        if ($restoreChoice -match "^\d+$" -and [int]$restoreChoice -lt $backups.Count) {
            $selectedBackup = $backups[[int]$restoreChoice].Path
            Restore-Backup -BackupPath $selectedBackup
            Write-Success "Settings restored"
        }
    }
    
    Write-Host ""
    Write-Host "Removing LinkUp Studio configurations..." -ForegroundColor Yellow
    Write-Host ""
    
    # Remove PowerShell profile modifications
    $profilePath = $PROFILE
    if (Test-Path $profilePath) {
        $content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
        if ($content -match "LinkUp Studio" -or $content -match "LinkUpStudio") {
            Write-Step "Cleaning PowerShell profile..."
            
            # Check for backup
            $profileBackup = "$profilePath.linkup.backup"
            if (Test-Path $profileBackup) {
                Copy-Item $profileBackup $profilePath -Force
                Remove-Item $profileBackup -Force
                Write-Success "PowerShell profile restored"
            } else {
                # Remove LinkUp Studio lines
                $newContent = ($content -split "`n") | Where-Object { 
                    $_ -notmatch "LinkUp Studio" -and 
                    $_ -notmatch "LinkUpStudio" -and
                    $_ -notmatch "linkup"
                } | Out-String
                Set-Content -Path $profilePath -Value $newContent -Force -Encoding UTF8
                Write-Success "PowerShell profile cleaned"
            }
        }
    }
    
    # Remove LinkUp Studio profile file
    $profileDir = Split-Path -Parent $profilePath
    $linkupProfile = Join-Path $profileDir "LinkUpStudio_profile.ps1"
    if (Test-Path $linkupProfile) {
        Remove-Item $linkupProfile -Force
        Write-Info "Removed: LinkUpStudio_profile.ps1"
    }
    
    # Remove Windows Terminal settings backup
    $wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path $wtSettingsPath) {
        $content = Get-Content $wtSettingsPath -Raw -ErrorAction SilentlyContinue
        if ($content -match "linkup" -or $content -match "LinkUp" -or $content -match "Developer Dashboard") {
            Write-Step "Cleaning Windows Terminal settings..."
            
            # Find and restore backup
            $wtBackup = Get-ChildItem -Path (Split-Path $wtSettingsPath -Parent) -Filter "*.backup.*" -ErrorAction SilentlyContinue | 
                Where-Object { $_.Name -match "linkup" } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
            
            if ($wtBackup) {
                Copy-Item $wtBackup.FullName $wtSettingsPath -Force
                Remove-Item $wtBackup.FullName -Force
                Write-Success "Windows Terminal settings restored"
            } else {
                Write-Info "Please manually restore Windows Terminal settings from Windows Terminal settings UI"
            }
        }
    }
    
    # Remove Oh My Posh theme
    $ompPath = $env:POSH_THEMES_PATH
    if ($ompPath) {
        $themePath = Join-Path $ompPath "linkup.omp.json"
        if (Test-Path $themePath) {
            Remove-Item $themePath -Force
            Write-Info "Removed: linkup.omp.json theme"
        }
    }
    
    # Restore default cursors
    Write-Step "Restoring default cursors..."
    $cursorPath = "HKCU:\Control Panel\Cursors"
    if (Test-Path $cursorPath) {
        # Set Windows default cursors
        $defaultCursors = @{
            "Arrow" = "%SystemRoot%\cursors\arrow_i.cur"
            "Help" = "%SystemRoot%\cursors\help_i.cur"
            "AppStarting" = "%SystemRoot%\cursors\wait_i.cur"
            "Wait" = "%SystemRoot%\cursors\wait_i.cur"
            "Crosshair" = "%SystemRoot%\cursors\cross_i.cur"
            "IBeam" = "%SystemRoot%\cursors\beam_i.cur"
            "No" = "%SystemRoot%\cursors\no_i.cur"
            "Hand" = "%SystemRoot%\cursors\link_i.cur"
            "SizeAll" = "%SystemRoot%\cursors\move_i.cur"
            "SizeNESW" = "%SystemRoot%\cursors\size1_i.cur"
            "SizeNS" = "%SystemRoot%\cursors\size4_i.cur"
            "SizeNWSE" = "%SystemRoot%\cursors\size2_i.cur"
            "SizeWE" = "%SystemRoot%\cursors\size3_i.cur"
            "UpArrow" = "%SystemRoot%\cursors\up_i.cur"
            "Pin" = "%SystemRoot%\cursors\pin_i.cur"
            "Person" = "%SystemRoot%\cursors\person_i.cur"
        }
        
        foreach ($cursor in $defaultCursors.Keys) {
            Set-ItemProperty -Path $cursorPath -Name $cursor -Value $defaultCursors[$cursor] -ErrorAction SilentlyContinue
        }
        
        Write-Success "Default cursors restored"
    }
    
    # Remove shortcuts
    Write-Step "Removing shortcuts..."
    
    $desktop = [Environment]::GetFolderPath("Desktop")
    $desktopShortcut = Join-Path $desktop "LinkUp Studio.lnk"
    if (Test-Path $desktopShortcut) {
        Remove-Item $desktopShortcut -Force
        Write-Info "Removed: Desktop shortcut"
    }
    
    $startMenu = [Environment]::GetFolderPath("StartMenu")
    $startShortcutDir = Join-Path $startMenu "Programs\LinkUp Studio"
    if (Test-Path $startShortcutDir) {
        Remove-Item $startShortcutDir -Recurse -Force
        Write-Info "Removed: Start Menu folder"
    }
    
    # Remove installation directory
    if (Test-Path $Config.InstallDir) {
        # Keep backups, remove other files
        $installFiles = Get-ChildItem -Path $Config.InstallDir -File
        foreach ($file in $installFiles) {
            if ($file.Name -notmatch "icons_config" -and $file.Name -notmatch "cursors_config") {
                Remove-Item $file.FullName -Force
            }
        }
        Write-Info "Cleaned: Installation directory"
    }
    
    # Remove registry key
    if (Test-Path $Config.RegistryPath) {
        Remove-Item $Config.RegistryPath -Recurse -Force
        Write-Info "Removed: Registry keys"
    }
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "║                    Uninstall Complete!                                         ║" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Please restart your terminal and VS Code for changes to take effect." -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Installation
# ═══════════════════════════════════════════════════════════════════════════════════════

function Install-LinkUpStudio {
    Write-Header "LinkUp Studio One-Click Installer"
    
    Write-Host "Version: $($Config.Version)" -ForegroundColor Gray
    Write-Host "Log file: $($Config.LogFile)" -ForegroundColor Gray
    Write-Host ""
    
    # Create installation directory
    if (-not (Test-Path $Config.InstallDir)) {
        New-Item -ItemType Directory -Path $Config.InstallDir -Force | Out-Null
    }
    
    # Backup existing settings
    if (-not $SkipBackup) {
        Write-Host ""
        Write-Host "─── Backup Phase ───" -ForegroundColor White
        Write-Host ""
        $backupPath = Backup-ExistingSettings
    }
    
    Write-Host ""
    Write-Host "─── Installation Phase ───" -ForegroundColor White
    Write-Host ""
    
    # Install all components
    Install-Fonts
    Install-IconPack
    Install-CustomCursors
    Install-WindowsTerminal
    Install-VSCodeSettings
    
    # Create shortcuts
    if (-not $SkipShortcuts) {
        Write-Host ""
        Write-Host "─── Creating Shortcuts ───" -ForegroundColor White
        Write-Host ""
        New-DesktopShortcut
        New-StartMenuShortcut
    }
    
    # Save installation info
    $installInfo = @{
        InstalledAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Version = $Config.Version
        BackupPath = if (-not $SkipBackup) { $backupPath } else { $null }
        InstalledComponents = @(
            if (-not $SkipFonts) { "fonts" }
            if (-not $SkipIcons) { "icons" }
            if (-not $SkipCursors) { "cursors" }
            if (-not $SkipTerminal) { "terminal" }
            if (-not $SkipVSCode) { "vscode" }
            if (-not $SkipShortcuts) { "shortcuts" }
        )
    } | ConvertTo-Json -Depth 3
    
    Set-Content -Path (Join-Path $Config.InstallDir "install_info.json") -Value $installInfo -Encoding UTF8
    
    # Save to registry
    if (-not (Test-Path $Config.RegistryPath)) {
        New-Item -Path $Config.RegistryPath -Force | Out-Null
    }
    Set-ItemProperty -Path $Config.RegistryPath -Name "Installed" -Value $true
    Set-ItemProperty -Path $Config.RegistryPath -Name "Version" -Value $Config.Version
    Set-ItemProperty -Path $Config.RegistryPath -Name "InstallDate" -Value (Get-Date -Format "yyyy-MM-dd")
    Set-ItemProperty -Path $Config.RegistryPath -Name "InstallPath" -Value $Config.InstallDir
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "║                    Installation Complete!                                      ║" -ForegroundColor Green
    Write-Host "║                                                                                ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1. Restart Windows Terminal" -ForegroundColor Cyan
    Write-Host "  2. Restart VS Code" -ForegroundColor Cyan
    Write-Host "  3. Enjoy your premium developer environment!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Quick Commands:" -ForegroundColor White
    Write-Host "  dev       - Developer dashboard" -ForegroundColor Gray
    Write-Host "  gst       - Git status" -ForegroundColor Gray
    Write-Host "  gco       - Git checkout" -ForegroundColor Gray
    Write-Host "  ni        - npm install" -ForegroundColor Gray
    Write-Host "  nr dev    - npm run dev" -ForegroundColor Gray
    Write-Host ""
    
    if (-not $SkipBackup -and $backupPath) {
        Write-Host "Backup saved to: $backupPath" -ForegroundColor Yellow
        Write-Host "To restore: Run installer with -Uninstall to restore from backup" -ForegroundColor Gray
        Write-Host ""
    }
    
    Write-Host "Uninstall: Run '.\Install-LinkUpStudio.ps1 -Uninstall'" -ForegroundColor Gray
    Write-Host ""
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# Main Entry Point
# ═══════════════════════════════════════════════════════════════════════════════════════

# Initialize log
$logDir = Split-Path -Parent $Config.LogFile
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
"LinkUp Studio Installer started at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Set-Content -Path $Config.LogFile -Encoding UTF8

# Handle uninstall
if ($Uninstall) {
    Uninstall-LinkUpStudio
    exit 0
}

# Run installation
try {
    Install-LinkUpStudio
} catch {
    Write-Error "Installation failed: $_"
    Log-Message "[FATAL] Installation failed: $_"
    exit 1
}

# ═══════════════════════════════════════════════════════════════════════════════════════
# LinkUp Studio One-Click Installer v1.0.0
# ═══════════════════════════════════════════════════════════════════════════════════════
