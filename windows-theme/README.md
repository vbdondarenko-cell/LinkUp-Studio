# 🎨 LinkUp Studio Windows Theme - GitHub Dark

A complete Windows 10/11 dark theme package inspired by GitHub's dark color scheme. Transform your entire Windows experience with a cohesive, professional dark interface.

![GitHub Dark Theme Preview](assets/preview.png)

## ✨ Features

- **Complete System Integration** - Title bars, taskbar, start menu, context menus
- **GitHub Dark Color Palette** - Consistent colors across all UI elements
- **High Resolution Wallpaper** - 4K wallpaper included
- **Easy Installation** - One-click installer script
- **Easy Uninstall** - Clean removal with revert script
- **Registry Tweaks** - System-wide dark mode activation

## 📦 Installation

### Quick Install (Recommended)

1. **Extract** the theme package to a folder
2. **Right-click** `install-theme.bat` and select **Run as administrator**
3. **Restart** your computer for full effect

### Manual Installation

1. Copy `GitHubDark.theme` to:
   ```
   C:\Windows\Resources\Themes\
   ```

2. Copy `GitHubDark.msstyles` to:
   ```
   C:\Windows\Resources\Themes\GitHubDark\
   ```

3. Copy wallpaper to:
   ```
   C:\Windows\Web\4K\Wallpaper\Windows\
   ```

4. Apply registry changes:
   - Double-click `activate-dark-mode.reg`
   - Click **Yes** to confirm

5. Go to **Settings → Personalization → Themes** and select **GitHub Dark**

### PowerShell Installation

```powershell
# Run as Administrator
.\Activate-GitHubDarkMode.ps1
```

## 🎨 Color Palette

### Base Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Canvas | `#0d1117` | Desktop, main background |
| Surface | `#161b22` | Panels, cards |
| Elevated | `#21262d` | Hover states, modals |
| Overlay | `#30363d` | Borders, dividers |

### Accent Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Blue | `#1f6feb` | Primary actions, links |
| Green | `#3fb950` | Success states |
| Yellow | `#d29922` | Warnings |
| Red | `#f85149` | Errors, danger |
| Purple | `#a371f7` | Special actions |

## 🔧 What's Included

### Files

```
windows-theme/
├── GitHubDark.theme         # Windows theme definition
├── GitHubDark.msstyles      # Visual styles (placeholder)
├── README.md                # This file
├── THEME-SPEC.md            # Detailed theme specification
├── assets/
│   ├── COLOR-PALETTE.md     # Complete color reference
│   ├── GitHubDark.svg       # Vector wallpaper source
│   └── GitHubDark.png       # Raster wallpaper (generate)
├── registry/
│   └── activate-dark-mode.reg  # Registry tweaks
└── scripts/
    ├── install-theme.bat    # Installation script
    ├── uninstall-theme.bat  # Uninstallation script
    └── Activate-GitHubDarkMode.ps1  # PowerShell activator
```

## 🖼️ Wallpaper

The package includes an SVG source file for the wallpaper. To generate the PNG:

1. Open `assets/GitHubDark.svg` in a browser
2. Screenshot at 3840x2160 resolution
3. Save as `assets/GitHubDark.png`

Or use any SVG to PNG converter.

### Wallpaper Design

- Base color: `#0d1117`
- Gradient overlay: `#161b22` to `#0d1117`
- Geometric accent pattern using `#30363d`
- Subtle octocat-inspired elements in `#1f6feb`

## ⚙️ Customization

### Changing Accent Color

Edit `activate-dark-mode.reg` and change the accent value:

```reg
"AccentColor"=dword:00feb61f
```

Valid accent colors:
- `#1f6feb` - GitHub Blue (default)
- `#3fb950` - GitHub Green
- `#f85149` - GitHub Red
- `#a371f7` - GitHub Purple
- `#d29922` - GitHub Yellow

### Taskbar Transparency (Windows 11)

The registry includes settings for taskbar transparency. Adjust in:

```reg
"TaskbarAcrylicOpacity"=dword:00000000
```

Values: `00` (solid) to `f0` (maximum transparency)

## 🗑️ Uninstallation

### Quick Uninstall

1. **Right-click** `uninstall-theme.bat` and select **Run as administrator**

### Manual Uninstall

1. Go to **Settings → Personalization → Themes**
2. Select a different theme
3. Delete `GitHubDark.theme` from `C:\Windows\Resources\Themes\`
4. Revert registry using the `-Uninstall` flag:
   ```powershell
   .\Activate-GitHubDarkMode.ps1 -Uninstall
   ```

## 🔍 Troubleshooting

### Theme not appearing in Settings

1. Ensure `.theme` file is in `C:\Windows\Resources\Themes\`
2. Ensure `.msstyles` is in `C:\Windows\Resources\Themes\GitHubDark\`
3. Restart Windows Explorer

### Colors not applying

1. Run the registry file as Administrator
2. Restart your computer
3. Check that **Color mode** is set to **Dark** in Settings

### Taskbar still light

1. Go to **Settings → Personalization → Colors**
2. Ensure **Show accent color on taskbar** is enabled
3. Ensure **Transparency effects** is toggled

### High CPU usage after install

This is normal during theme application. Restart your computer.

## 📋 System Requirements

- **Windows 10** (version 1903 or later)
- **Windows 11** (partial support)
- **Administrator privileges** for installation

## ⚠️ Limitations

- Windows 11 rounded corners cannot be fully themed
- Some third-party applications need their own dark mode
- Start menu customization is limited on Windows 11
- Registry changes require restart for full effect

## 📄 License

This theme package is created for personal use. GitHub colors and branding are trademarks of GitHub, Inc.

## 🙏 Credits

- **Theme Design:** LinkUp Studio
- **Color Inspiration:** [GitHub Dark](https://github.com/settings/appearance)
- **Framework:** Windows 10/11 Theme System

---

**Part of LinkUp Studio - Premium Windows Developer Environment**