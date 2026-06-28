# LinkUp Studio Windows Experience - Installation Guide

## Prerequisites

### System Requirements
- Windows 10 version 1809 or later
- Windows 11 (any version)
- PowerShell 5.1 or later
- Administrator privileges

### Recommended Software
- Visual Studio Code
- Windows Terminal
- Git for Windows
- OpenHands (optional)

## Pre-Installation Checklist

1. ✅ Ensure you have administrator privileges
2. ✅ Close any running applications
3. ✅ Disable antivirus temporarily (if needed)
4. ✅ Create a system restore point (optional)

## Installation Methods

### Method 1: PowerShell Script (Recommended)

#### Full Installation
```powershell
# Navigate to the scripts folder
cd Path\to\LinkUp-Studio\windows-experience\scripts

# Run as Administrator
.\Install-LinkUpStudio-Experience.ps1
```

#### Selective Installation
```powershell
# Theme only
.\Install-LinkUpStudio-Experience.ps1 -ThemeOnly

# Icons only
.\Install-LinkUpStudio-Experience.ps1 -IconsOnly

# Shortcuts and folders only
.\Install-LinkUpStudio-Experience.ps1 -ShortcutsOnly
```

#### Silent Installation
```powershell
# Silent mode (for automation)
.\Install-LinkUpStudio-Experience.ps1 -Silent
```

### Method 2: Manual Installation

#### Installing the Theme

1. **Navigate to themes folder:**
   ```
   LinkUp-Studio\windows-experience\themes\
   ```

2. **Double-click GitHubDark.theme:**
   - Windows will prompt for permission
   - Click "Apply" to install

3. **Or copy manually:**
   ```powershell
   Copy-Item "GitHubDark.theme" "$env:LOCALAPPDATA\Microsoft\Windows\Themes\"
   ```

4. **Apply via Settings:**
   - Open Windows Settings
   - Go to Personalization → Themes
   - Select "GitHubDark" from the theme list

#### Installing Wallpaper

1. **Navigate to wallpapers folder:**
   ```
   LinkUp-Studio\windows-experience\wallpapers\
   ```

2. **Right-click the wallpaper:**
   - Select "Set as desktop background"

3. **Or via PowerShell:**
   ```powershell
   $wallpaper = "Path\to\LinkUp-Studio\windows-experience\wallpapers\github-dark.png"
   Add-Type -AssemblyName System.Drawing
   Add-Path = "HKCU:\Control Panel\Desktop"
   Set-ItemProperty -Path $addPath -Name Wallpaper -Value $wallpaper
   Set-ItemProperty -Path $addPath -Name WallpaperStyle -Value 10
   ```

#### Creating Desktop Shortcuts

1. **Right-click on desktop:**
   - Select New → Shortcut

2. **Enter the application path:**
   - VS Code: `code`
   - Windows Terminal: `wt`
   - GitHub: `https://github.com`

3. **Browse for application:**
   - Click "Browse"
   - Navigate to application executable

#### Creating Developer Folders

1. **Open File Explorer:**
   - Navigate to your home folder: `C:\Users\<YourName>`

2. **Create new folders:**
   - Right-click → New → Folder
   - Name them:
     - Projects
     - Repositories
     - AI
     - Design
     - Scripts
     - Tools
     - Archives

## Post-Installation Steps

### 1. Log Out and Log In
Some changes require logging out:
```powershell
Logoff
```

### 2. Configure Taskbar (Manual)

1. **Right-click taskbar:**
   - Select Taskbar settings

2. **Configure options:**
   - Auto-hide taskbar (optional)
   - Taskbar icon size
   - Taskbar position

### 3. Pin Applications

1. **Open desired application**
2. **Right-click in taskbar:**
   - Select "Pin to taskbar"

### 4. Arrange Desktop Icons

1. **Right-click desktop:**
   - Select View → Auto arrange icons
   - Select Sort by → Name

### 5. Configure File Explorer

1. **Open File Explorer:**
   - Click View → Options

2. **Appearance:**
   - Enable dark mode in Windows Settings

3. **Navigation Pane:**
   - Show: Downloads, Desktop, Documents
   - Hide: Home group, Network

## Troubleshooting

### Theme Not Applying

**Problem:** Theme doesn't appear in Windows Settings

**Solution:**
1. Ensure the .theme file is in: `%LOCALAPPDATA%\Microsoft\Windows\Themes\`
2. Try logging out and logging back in
3. Run: `rundll32.exe desk.cpl,InstallThemeFile "C:\Path\To\GitHubDark.theme"`

### Wallpaper Not Showing

**Problem:** Wallpaper appears blank or default

**Solution:**
1. Check registry setting:
   ```powershell
   Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper
   ```
2. Set wallpaper properly:
   ```powershell
   Add-Type -AssemblyName System.Drawing
   $wallpaper = "C:\Path\to\wallpaper.png"
   Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaper
   ```

### Shortcuts Not Working

**Problem:** Desktop shortcuts don't open applications

**Solution:**
1. Verify application is installed
2. Check shortcut path
3. Recreate shortcut

### Dark Mode Issues

**Problem:** Some apps don't respect dark mode

**Solution:**
1. Enable dark mode for all apps in Windows Settings:
   - Settings → Personalization → Colors
   - Turn on "Show accent color on title bars and window borders"
   - Turn on "Dark" under "Choose your mode"

## Advanced Configuration

### Enabling Dark Mode via Registry

```powershell
# Enable dark mode for Windows
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

# Enable dark mode for apps
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
```

### Customizing Taskbar

```powershell
# Taskbar size (requires restart)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSize" -Value 1

# Taskbar auto-hide (requires restart)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAutoHide" -Value 1
```

## Backup and Restore

### Automatic Backup

The installer automatically backs up:
- Current theme
- Current wallpaper
- Registry settings

Backup location: `%LOCALAPPDATA%\LinkUpStudio\Backups\<timestamp>\`

### Manual Backup

```powershell
# Backup current theme
Copy-Item "$env:LOCALAPPDATA\Microsoft\Windows\Themes\GitHubDark.theme" "Path\to\backup\"

# Backup wallpaper
Copy-Item "Path\to\wallpaper.png" "Path\to\backup\"
```

### Restore from Backup

```powershell
.\Uninstall-LinkUpStudio-Experience.ps1 -Restore
```

## Uninstalling Components

### Remove Theme Only
1. Open Windows Settings
2. Go to Personalization → Themes
3. Select a different theme

### Remove Shortcuts Only
1. Right-click desktop shortcut
2. Select Delete

### Remove Folders Only
1. Verify folders are empty
2. Right-click → Delete

### Full Uninstall
```powershell
.\Uninstall-LinkUpStudio-Experience.ps1 -CleanAll
```

## Support

### Getting Help

1. Check the troubleshooting section
2. Review Windows Event Viewer
3. Check logs: `%LOCALAPPDATA%\LinkUpStudio\Logs\`

### Reporting Issues

Please open an issue at:
https://github.com/vbdondarenko-cell/LinkUp-Studio/issues

---

**Last Updated:** June 2024
**Version:** 1.0.0
