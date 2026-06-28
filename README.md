# 🔗 LinkUp Studio

### Premium Developer Workspace for Windows

[![GitHub stars](https://img.shields.io/github/stars/vbdondarenko-cell/LinkUp-Studio?style=social)](https://github.com/vbdondarenko-cell/LinkUp-Studio)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 🎯 What is LinkUp Studio?

**LinkUp Studio** transforms your Windows PC into a cohesive developer environment where everything looks and feels like one product.

### The Vision

> You turn on your PC, and within 10 seconds, you have:
> - ✅ GitHub already open
> - ✅ OpenHands AI assistant running
> - ✅ Terminal ready with your project
> - ✅ Everything styled in GitHub Dark theme
> - ✅ No manual setup needed

## ✨ Features

### 🎨 Visual Design
- **GitHub Dark** color palette throughout
- **LinkUp** branded elements
- Custom icons and cursors
- Beautiful splash screen

### 💻 Developer Environment
- **Windows Terminal** with GitHub Dark theme
- **PowerShell** profile with developer shortcuts
- **VS Code** theme integration
- Git shortcuts: `gst`, `gpush`, `gcm`, etc.

### ⚡ Automation
- **Auto-startup** - Launch apps when Windows starts
- **Project restoration** - Reopen your last project
- **One-command setup** - Install everything with one click

### 📦 Complete Installer
- One `.exe` installer
- Installs theme, fonts, icons, cursors
- Configures terminal and PowerShell
- Sets up auto-startup
- Fully reversible

## 🚀 Quick Start

### One-Click Install

```powershell
# Download and run
git clone https://github.com/vbdondarenko-cell/LinkUp-Studio.git
cd LinkUp-Studio\installer
.\OneClick-Install.bat
```

### Manual Install

```powershell
# Run PowerShell as Administrator
cd LinkUp-Studio\installer
.\LinkUp-Studio-OneClick-Installer.ps1
```

### Selective Install

```powershell
# Only terminal and profile
.\LinkUp-Studio-OneClick-Installer.ps1 -SkipIcons -SkipCursors -SkipVSCode

# Minimal install (terminal only)
.\LinkUp-Studio-OneClick-Installer.ps1 -Minimal
```

## 📁 Project Structure

```
LinkUp-Studio/
├── 📄 index.html              # Web-based IDE interface
├── 🎨 css/                   # Styles (variables, base, components, layout)
├── ⚡ js/                    # JavaScript (app, command palette, terminal)
├── 🖥️  windows-experience/    # Windows customization
│   ├── 🖼️ wallpapers/        # Custom wallpapers
│   ├── 🖼️ icons/             # Custom icons
│   └── 🎨 themes/            # Windows themes
├── 🖥️  windows-terminal/     # Terminal configuration
│   ├── settings.json          # Terminal settings
│   └── Microsoft.PowerShell_profile.ps1
├── 🖱️  cursors/             # Custom cursors
├── 🚀 installer/             # Installation scripts
│   ├── LinkUp-Studio-OneClick-Installer.ps1
│   ├── startup/              # Auto-startup scripts
│   └── innosetup/           # Inno Setup for .exe
├── ✨ splash/                # Splash screen
└── 📚 design-system/         # Design tokens
```

## 🎮 Quick Commands

After installation, use these commands in PowerShell:

| Command | Description |
|---------|-------------|
| `dev` | Developer dashboard |
| `sysinfo` | System information |
| `oh` | Launch OpenHands |
| `proj <name>` | Open project |
| `gst` | Git status |
| `gpush` | Git push |
| `gcm "msg"` | Git commit |
| `nr dev` | npm run dev |
| `dps` | Docker ps |

## 🎨 Screenshots

```
╔══════════════════════════════════════════════════════════════════════════╗
║                                                               ║
║   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗            ║
║   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝            ║
║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗            ║
║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║            ║
║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║            ║
║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝            ║
║                                                               ║
║           Premium Developer Workspace v2.0.0                  ║
╚══════════════════════════════════════════════════════════════════════════╝
```

## 🔧 Configuration

### Startup Configuration

Edit `startup_config.json`:

```json
{
  "urls": {
    "browser": "https://app.all-hands.dev",
    "github": "https://github.com"
  },
  "paths": {
    "projectPath": "C:\\Projects\\MyProject"
  },
  "launchOptions": {
    "launchTerminal": true,
    "launchOpenHands": true,
    "launchBrowser": true,
    "launchGitHub": true
  }
}
```

### Terminal Profiles

- **Developer Dashboard** - Main terminal with git info
- **Git Status** - Git-focused terminal
- **Quick Terminal** - Minimal terminal

## 📋 Requirements

- Windows 10/11
- PowerShell 5.1+
- Windows Terminal (recommended)
- Administrator privileges (for install)

## 📥 Installation Options

### Full Install
```powershell
.\LinkUp-Studio-OneClick-Installer.ps1 -Full
```

### Selective Install
```powershell
# Just terminal
.\LinkUp-Studio-OneClick-Installer.ps1 -SkipIcons -SkipCursors

# Just startup
.\LinkUp-Studio-OneClick-Installer.ps1 -SkipTerminal -SkipVSCode
```

### Uninstall
```powershell
.\LinkUp-Studio-OneClick-Installer.ps1 -Uninstall
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 🙏 Credits

Inspired by:
- GitHub Dark Theme
- Linear Design
- Raycast
- Arc Browser
- Warp Terminal

---

**Built with ❤️ for developers who value consistency and style.**

⭐ Star this repo if you found it useful!