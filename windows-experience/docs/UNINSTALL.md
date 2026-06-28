# LinkUp Studio Windows Experience - Uninstallation Guide

## Overview

This guide explains how to safely remove LinkUp Studio Windows Experience customizations and restore your original Windows settings.

## ⚠️ Important Notes

1. **Backup First**: Uninstall will create a backup of current settings
2. **Restart Required**: Most changes require restarting Windows
3. **Manual Steps**: Some settings must be restored manually

## Uninstallation Methods

### Method 1: PowerShell Script (Recommended)

#### Standard Uninstall
```powershell
# Navigate to scripts folder
cd Path\to\LinkUp-Studio\windows-experience\scripts

# Run as Administrator
.\Uninstall-LinkUpStudio-Experience.ps1
```

#### Uninstall with Backup Restore
```powershell
# Restore settings from most recent backup
.\Uninstall-LinkUpStudio-Experience.ps1 -Restore
```

#### Clean Everything
```powershell
# Remove all LinkUp Studio files and settings
.\Uninstall-LinkUpStudio-Experience.ps1 -CleanAll
```

### Method 2: Manual Uninstall

## Step-by-Step Manual Uninstall

### 1. Remove Windows Theme

#### Via Settings
1. Open Windows Settings
2. Go to **Personalization** → **Themes**
3. Select a different theme (e.g., "Windows (default)")

#### Via File Explorer
1. Navigate to: `%LOCALAPPDATA%\Microsoft\Windows\Themes\`
2. Delete `GitHubDark.theme`
3. Delete `GitHubDark.theme.backup`

### 2. Restore Wallpaper

#### Via Settings
1. Right-click desktop
2. Select **Personalize**
3. Choose a different wallpaper

#### Via PowerShell
```powershell
# Reset to default
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value ""
```

### 3. Restore Dark Mode Settings

#### Re-enable Light Mode
```powershell
# Enable light mode for Windows
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1

# Enable light mode for apps
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
```

### 4. Remove Desktop Shortcuts

Remove these shortcuts from your desktop:
- VS Code
- Windows Terminal
- GitHub
- OpenHands

**Method:**
1. Right-click the shortcut
2. Select **Delete**

### 5. Remove Start Menu Folder

1. Navigate to: `%APPDATA%\Microsoft\Windows\Start Menu\Programs\
2. Delete the **LinkUp Studio** folder

### 6. Remove Developer Folders

**Only delete if empty!**

Navigate to your home folder: `C:\Users\<YourName>\`

Delete these folders (if created by LinkUp Studio):
- Projects
- Repositories
- AI
- Design
- Scripts
- Tools
- Archives

### 7. Restore Icon Settings

#### Desktop Icons
1. Right-click desktop → Personalize
2. Click **Themes** → **Desktop icon settings**
3. Click **Restore Default**

#### Folder Icons
1. Right-click any customized folder
2. Select **Properties** → **Customize**
3. Click **Change Icon**
4. Browse to: `%SystemRoot%\System32\shell32.dll`
5. Select a default icon → OK

### 8. Remove Installation Files

```powershell
# Remove installation directory
Remove-Item -Path "$env:LOCALAPPDATA\LinkUpStudio" -Recurse -Force

# Remove backup directory (optional)
Remove-Item -Path "$env:LOCALAPPDATA\LinkUpStudio" -Recurse -Force
```

### 9. Clear Registry Entries (Advanced)

**⚠️ Only edit registry if confident!**

```powershell
# View current settings
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# Reset to defaults
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
```

## Restoring from Backup

### Automatic Restore

```powershell
.\Uninstall-LinkUpStudio-Experience.ps1 -Restore
```

### Manual Restore

1. **Find your backup:**
   ```
   %LOCALAPPDATA%\LinkUpStudio\Backups\<timestamp>\
   ```

2. **Restore wallpaper:**
   - Copy `wallpaper_backup.bmp` to your Pictures folder
   - Set as wallpaper

3. **Restore theme:**
   - Copy theme file to: `%LOCALAPPDATA%\Microsoft\Windows\Themes\`
   - Apply via Windows Settings

4. **Restore registry:**
   - Open the backup's manifest.json
   - Manually apply registry changes

## Cleanup Checklist

Use this checklist to ensure complete removal:

- [ ] Windows theme removed
- [ ] Wallpaper restored
- [ ] Dark mode settings restored (optional)
- [ ] Desktop shortcuts deleted
- [ ] Start Menu folder deleted
- [ ] Developer folders deleted (or moved)
- [ ] Custom folder icons restored
- [ ] LinkUp Studio installation directory deleted
- [ ] Backup directory cleaned
- [ ] Restarted Windows

## Troubleshooting

### Theme Won't Remove

**Problem:** Theme persists after uninstall

**Solution:**
```powershell
# Force apply default theme
rundll32.exe desk.cpl,InstallThemeFile "$env:SystemRoot\Resources\Themes\aero.theme"
```

### Wallpaper Won't Change

**Problem:** Wallpaper shows blank or black

**Solution:**
```powershell
# Clear wallpaper registry
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value ""

# Restart Explorer
Stop-Process -Name explorer -Force
Start-Process explorer
```

### Desktop Icons Missing

**Problem:** Default icons disappeared

**Solution:**
1. Right-click desktop → Personalize
2. Themes → Desktop icon settings
3. Check boxes for icons you want
4. Click OK

### Dark Mode Still Active

**Problem:** Windows still in dark mode

**Solution:**
1. Windows Settings → Personalization → Colors
2. Under "Choose your mode" select **Light**
3. Restart Windows

### Folders Won't Delete

**Problem:** "The folder is in use" error

**Solution:**
1. Close all File Explorer windows
2. Open Task Manager (Ctrl+Shift+Esc)
3. End task "Windows Explorer"
4. File → Run new task → explorer
5. Try deleting again

## Complete System Restore

If you want to completely start fresh:

### 1. Uninstall via PowerShell
```powershell
.\Uninstall-LinkUpStudio-Experience.ps1 -CleanAll -Restore
```

### 2. Remove all LinkUp Studio files
```powershell
Remove-Item -Path "$env:LOCALAPPDATA\LinkUpStudio" -Recurse -Force
```

### 3. Restart Windows
```powershell
Restart-Computer
```

### 4. Manually verify
- Theme is default
- Wallpaper is default
- No LinkUp Studio files exist
- No LinkUp Studio folders exist

## Re-installation

To reinstall after uninstallation:

```powershell
cd Path\to\LinkUp-Studio\windows-experience\scripts
.\Install-LinkUpStudio-Experience.ps1
```

## Support

### Getting Help

1. Check this troubleshooting guide
2. Review Windows Event Viewer
3. Check logs: `%LOCALAPPDATA%\LinkUpStudio\Logs\`

### Reporting Issues

Please open an issue at:
https://github.com/vbdondarenko-cell/LinkUp-Studio/issues

### Common Issues Quick Fix

| Issue | Quick Fix |
|-------|-----------|
| Theme won't change | Restart Windows |
| Wallpaper blank | Clear wallpaper registry |
| Icons missing | Restore via Settings |
| Dark mode persists | Enable light mode manually |
| Folders in use | Close Explorer, retry |

## Rollback Information

### Backup Location
```
%LOCALAPPDATA%\LinkUpStudio\Backups\<timestamp>\
```

### Backup Contents
- `manifest.json` - Settings manifest
- `wallpaper_backup.bmp` - Original wallpaper
- Registry settings (if exported)

### Backup Duration
Backups are kept until manually deleted or `CleanAll` is used.

---

**Last Updated:** June 2024
**Version:** 1.0.0
