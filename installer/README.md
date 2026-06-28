# LinkUp Studio Installer

A comprehensive one-click installer for the LinkUp Studio premium developer environment.

## Features

- ✅ **Install Fonts** - JetBrains Mono font setup
- ✅ **Install Icons** - Custom folder icons
- ✅ **Install Cursors** - Premium dark theme cursors
- ✅ **Configure Windows Terminal** - GitHub Dark theme with custom profiles
- ✅ **Configure PowerShell** - Enhanced profile with shortcuts
- ✅ **Configure VS Code** - Dark theme and editor settings
- ✅ **Create Desktop Shortcut** - Quick launch from desktop
- ✅ **Create Start Menu Shortcut** - Easy access from Start Menu
- ✅ **Backup Previous Settings** - Automatic backup before installation
- ✅ **One-Click Uninstall** - Complete removal with optional restore

## Quick Start

### One-Click Install

```powershell
# Download the installer
git clone https://github.com/vbdondarenko-cell/LinkUp-Studio.git

# Navigate to installer
cd LinkUp-Studio\installer

# Run as Administrator
.\Install-LinkUpStudio.ps1
```

### With PowerShell

```powershell
# Download and run directly (PowerShell 5.1+)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/vbdondarenko-cell/LinkUp-Studio/main/installer/Install-LinkUpStudio.ps1" -OutFile "$env:TEMP\Install-LinkUpStudio.ps1"
Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$env:TEMP\Install-LinkUpStudio.ps1`""
```

## Usage

### Full Installation (Default)

```powershell
.\Install-LinkUpStudio.ps1
```

### Skip Specific Components

```powershell
# Skip font installation
.\Install-LinkUpStudio.ps1 -SkipFonts

# Skip VS Code configuration
.\Install-LinkUpStudio.ps1 -SkipVSCode

# Skip everything except Windows Terminal
.\Install-LinkUpStudio.ps1 -SkipFonts -SkipIcons -SkipCursors -SkipVSCode -SkipShortcuts
```

### Skip Backup

```powershell
# Skip backing up existing settings
.\Install-LinkUpStudio.ps1 -SkipBackup
```

### Silent Installation

```powershell
# Silent mode (minimal output)
.\Install-LinkUpStudio.ps1 -Silent
```

### Verbose Mode

```powershell
# Show detailed logging
.\Install-LinkUpStudio.ps1 -Verbose
```

### Uninstallation

```powershell
# One-click uninstall with restore option
.\Install-LinkUpStudio.ps1 -Uninstall
```

## What Gets Installed

### 1. Fonts
- JetBrains Mono (recommended for terminal and code)
- Instructions provided for manual installation if winget fails

### 2. Icon Pack
Custom folder icons for:
- Desktop
- Documents
- Downloads
- Music
- Pictures
- Videos

### 3. Custom Cursors
Dark theme cursor set:
- Normal pointer
- Text cursor (I-beam)
- Link pointer (hand)
- Loading cursor
- Resize cursors
- Move cursor

### 4. Windows Terminal
- GitHub Dark color scheme
- Custom profiles:
  - **Developer Dashboard** - Enhanced prompt with git info
  - **Git Status** - Git-focused terminal
  - **Quick Terminal** - Minimal terminal
- JetBrains Mono font
- Acrylic background effects

### 5. PowerShell Profile
Enhanced prompt with:
- Git repository information
- System information
- Quick aliases:
  - `dev` - Developer dashboard
  - `gst` - Git status
  - `gco` - Git checkout
  - `gcm` - Git commit
  - `ni` - npm install
  - `nr` - npm run
  - `dps` - Docker ps
  - `sys` - System information

### 6. VS Code Settings
- GitHub Dark Default theme
- JetBrains Mono font
- Editor optimizations
- Terminal settings
- Git settings

### 7. Shortcuts
- Desktop shortcut to Windows Terminal (Developer Dashboard)
- Start Menu folder with:
  - LinkUp Studio shortcut
  - Uninstall shortcut

## Backup & Restore

### Automatic Backup
Before installation, the installer automatically backs up:
- PowerShell profile
- Windows Terminal settings
- Cursor registry settings
- VS Code settings

Backups are stored in:
```
%LOCALAPPDATA%\LinkUpStudio\Backups\<timestamp>\
```

### Restore from Backup
1. Run uninstaller: `.\Install-LinkUpStudio.ps1 -Uninstall`
2. Select a backup to restore
3. Settings will be reverted

### Manual Restore
```powershell
# List available backups
Get-ChildItem "$env:LOCALAPPDATA\LinkUpStudio\Backups"

# Restore specific backup
$backupPath = "$env:LOCALAPPDATA\LinkUpStudio\Backups\<timestamp>"
# Manually copy files from backup to original locations
```

## Requirements

- Windows 10 version 1809 or later
- Windows 11
- PowerShell 5.1 or later
- Windows Terminal (recommended)
- VS Code (optional)

### Recommended Software
- [Windows Terminal](https://aka.ms/terminal)
- [VS Code](https://code.visualstudio.com/)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- [Oh My Posh](https://ohmyposh.dev/)

## Uninstall

### One-Click Uninstall
```powershell
.\Install-LinkUpStudio.ps1 -Uninstall
```

This will:
1. Prompt to restore from backup
2. Remove PowerShell profile modifications
3. Restore Windows Terminal settings
4. Remove custom cursors
5. Remove desktop and Start Menu shortcuts
6. Clean up installation files

### Manual Uninstall

If you need to manually remove:

1. **PowerShell Profile**: Remove LinkUp Studio lines from `$PROFILE`
2. **Windows Terminal**: Settings → Reset to default
3. **Cursors**: Settings → Personalization → Cursors → Reset
4. **Shortcuts**: Delete from Desktop and Start Menu
5. **VS Code**: Reset color theme and editor settings

## Troubleshooting

### "Running scripts is disabled on this system"
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Oh My Posh not found"
```powershell
# Install manually
winget install JanDeDobbeleer.OhMyPosh
```

### "Windows Terminal settings not found"
Launch Windows Terminal once to generate the settings file.

### Cursors not updating
Log out and log back in, or restart Explorer:
```powershell
Stop-Process -Name explorer -Force
Start-Process explorer
```

## File Structure

```
installer/
├── Install-LinkUpStudio.ps1    # Main installer script
└── README.md                  # This file

LinkUp-Studio/
├── installer/                  # One-click installer
├── powershell/                # PowerShell profile
├── windows-terminal/          # Windows Terminal config
├── icons/                     # Icon pack
├── cursors/                   # Cursor pack
└── windows-theme/             # Windows theme
```

## License

MIT License - See main repository for details.

## Contributing

Contributions welcome! Please open an issue or pull request.
