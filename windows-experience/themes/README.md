# LinkUp Studio Windows Theme

## Overview

This folder contains Windows theme files for the LinkUp Studio premium developer experience.

## Files

| File | Description |
|------|-------------|
| `GitHubDark.theme` | Complete Windows theme (click to install) |
| `GitHubDark.colors` | Color scheme definition |
| `README.md` | This file |

## Installation

### Method 1: Double-Click
1. Navigate to this folder
2. Double-click `GitHubDark.theme`
3. Click "Apply" when prompted

### Method 2: Manual
1. Copy `GitHubDark.theme` to: `%LOCALAPPDATA%\Microsoft\Windows\Themes\`
2. Open Windows Settings → Personalization → Themes
3. Select "GitHubDark" from the theme list

### Method 3: PowerShell
```powershell
Copy-Item "GitHubDark.theme" "$env:LOCALAPPDATA\Microsoft\Windows\Themes\"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ThemeID" -Value "GitHubDark"
```

## Theme Specifications

### Colors

| Element | Color | Hex |
|---------|-------|-----|
| Background | Dark Canvas | #0D1117 |
| Surface | Dark Surface | #161B22 |
| Elevated | Elevated | #21262D |
| Border | Border | #30363D |
| Accent | GitHub Blue | #58A6FF |
| Text Primary | Light | #E6EDF3 |
| Text Secondary | Muted | #8B949E |

### Features

- **Dark title bars** with GitHub Blue accent
- **Dark window borders** for seamless appearance
- **Dark menus and tooltips** for consistency
- **Dark scrollbars** matching the theme
- **Modern selection colors** with accent highlights

## Uninstallation

### Method 1: Settings
1. Open Windows Settings → Personalization → Themes
2. Select any other theme

### Method 2: PowerShell
```powershell
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Themes\GitHubDark.theme"
```

## Notes

- This theme modifies only **user-level** settings
- No system files are modified
- Theme is fully reversible
- Compatible with Windows 10 and Windows 11

## Wallpaper

For best results, use the LinkUp Studio wallpaper from the `wallpapers/` folder.

## Credits

Theme based on GitHub Dark design language.
Created for LinkUp Studio premium developer experience.
