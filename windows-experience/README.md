# LinkUp Studio Windows Experience

A comprehensive Windows 10/11 desktop customization package that transforms your Windows experience into a premium developer workspace inspired by GitHub, Linear, Arc Browser, and Raycast.

## 🎯 Features

### Desktop Experience
- **GitHub Dark Theme** - Seamless dark mode across Windows
- **Premium Wallpapers** - High-quality dark wallpapers
- **Custom Icons** - Developer-focused icon set
- **Organized Folders** - Logical developer folder structure

### Taskbar & Start Menu
- **Dark Taskbar** - Clean, minimal appearance
- **Quick Access** - Developer apps prioritized
- **Custom Start Menu** - Streamlined application organization

### File Explorer
- **Dark Explorer** - Consistent dark appearance
- **Custom Folder Icons** - GitHub-inspired design
- **Quick Access Organization** - Logical sidebar

### Developer Tools
- **VS Code Integration** - Quick launch shortcuts
- **Windows Terminal** - Pre-configured dark theme
- **GitHub Integration** - Desktop and website shortcuts
- **OpenHands** - AI assistant quick access

## 📁 Contents

```
windows-experience/
├── themes/           # Windows theme files
│   ├── GitHubDark.theme
│   ├── GitHubDark.colors
│   └── README.md
├── icons/            # Custom Windows icons
│   ├── ico/          # Icon files (.ico)
│   └── README.md
├── wallpapers/       # Desktop wallpapers
├── scripts/          # Installation scripts
│   ├── Install-LinkUpStudio-Experience.ps1
│   └── Uninstall-LinkUpStudio-Experience.ps1
└── docs/             # Documentation
    ├── README.md
    ├── INSTALL.md
    └── UNINSTALL.md
```

## 🚀 Quick Start

### One-Click Installation

```powershell
# Run as Administrator
cd LinkUp-Studio\windows-experience\scripts
.\Install-LinkUpStudio-Experience.ps1
```

### Step-by-Step

1. Download the repository:
```powershell
git clone https://github.com/vbdondarenko-cell/LinkUp-Studio.git
```

2. Navigate to the scripts folder:
```powershell
cd LinkUp-Studio\windows-experience\scripts
```

3. Run the installer:
```powershell
.\Install-LinkUpStudio-Experience.ps1
```

4. Log out and log back in for changes to take effect

## 📦 Installation Options

### Full Installation (Recommended)
```powershell
.\Install-LinkUpStudio-Experience.ps1
```
Installs all components: theme, icons, folders, shortcuts

### Theme Only
```powershell
.\Install-LinkUpStudio-Experience.ps1 -ThemeOnly
```
Installs only the Windows theme and wallpaper

### Icons Only
```powershell
.\Install-LinkUpStudio-Experience.ps1 -IconsOnly
```
Installs only the custom desktop icons

### Shortcuts Only
```powershell
.\Install-LinkUpStudio-Experience.ps1 -ShortcutsOnly
```
Creates folders and shortcuts only

### Silent Installation
```powershell
.\Install-LinkUpStudio-Experience.ps1 -Silent
```
Installs with minimal output

## 🔧 What Gets Installed

### Windows Theme
- Dark title bars with GitHub Blue accent (#58A6FF)
- Custom color scheme matching LinkUp Studio design
- GitHub Dark wallpaper

### Desktop Shortcuts
- VS Code
- Windows Terminal
- GitHub
- OpenHands

### Developer Folders
```
~/
├── Projects/      # Your coding projects
├── Repositories/ # Git repositories
├── AI/          # AI/ML projects
├── Design/       # Design files
├── Scripts/      # Utility scripts
├── Tools/        # Development tools
└── Archives/     # Archived projects
```

### Registry Tweaks
- Dark mode enabled for Windows
- Dark mode enabled for apps
- File association hints for developers

## 🛡️ Safety Features

### Backup System
- All current settings are backed up automatically
- Backups stored in: `%LOCALAPPDATA%\LinkUpStudio\Backups\`
- Each backup includes manifest with settings info

### Reversibility
- **100% Reversible** - All changes can be undone
- **No System Files Modified** - Only user-level settings
- **Safe Registry Changes** - Uses Windows API properly

### Uninstall Options
```powershell
# Standard uninstall
.\Uninstall-LinkUpStudio-Experience.ps1

# With backup restore
.\Uninstall-LinkUpStudio-Experience.ps1 -Restore

# Clean everything
.\Uninstall-LinkUpStudio-Experience.ps1 -CleanAll
```

## 🎨 Design Language

### Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Canvas | GitHub Dark | #0D1117 |
| Surface | Surface | #161B22 |
| Elevated | Elevated | #21262D |
| Border | Border | #30363D |
| Accent | GitHub Blue | #58A6FF |
| Text Primary | Light | #E6EDF3 |
| Text Secondary | Muted | #8B949E |

### Typography

- **UI Font**: Segoe UI (Windows default)
- **Code Font**: JetBrains Mono
- **Fallback**: System UI

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Windows 10 (1809+) | ✅ Supported |
| Windows 11 | ✅ Supported |
| Windows Server | ⚠️ Limited |

## 🔧 Requirements

- **Windows 10 version 1809** or later
- **Windows 11** (any version)
- **PowerShell 5.1** or later
- **Administrator privileges** (for installation)

## ⚠️ Important Notes

1. **Backup First**: The installer automatically backs up your current settings
2. **Log Out Required**: Some changes require logging out to take effect
3. **Icons Need Manual Setup**: Some desktop icons require manual configuration
4. **Taskbar Settings**: Auto-hide and other taskbar options are configured manually

## 📖 Documentation

- [Installation Guide](docs/INSTALL.md)
- [Uninstallation Guide](docs/UNINSTALL.md)
- [Theme Documentation](themes/README.md)
- [Icons Documentation](icons/README.md)

## 🤝 Contributing

Contributions welcome! Please open an issue or pull request.

## 📄 License

MIT License - See main repository for details.

## 🙏 Credits

Inspired by:
- GitHub Dark Theme
- Linear Design
- Arc Browser
- Raycast
- Warp Terminal
- Apple Human Interface Guidelines

---

**LinkUp Studio Windows Experience** - Premium Developer Desktop
