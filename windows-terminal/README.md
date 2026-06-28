# LinkUp Studio Windows Terminal Configuration

Premium Windows Terminal setup with **GitHub Dark** theme, **JetBrains Mono**, and **Git integration**.

## ✨ Features

- **GitHub Dark Theme** - Complete color scheme matching GitHub Dark
- **JetBrains Mono** - Modern monospace font with ligatures
- **Git Integration** - Branch indicator, status icons, repository info
- **Developer Dashboard** - Quick access to development tools
- **Oh My Posh** - Beautiful, customizable prompt
- **Multiple Profiles** - PowerShell, Git, Quick Terminal
- **Modern Animations** - Smooth transitions and acrylic effects
- **Keyboard Shortcuts** - Efficient workflow navigation

## 📦 Installation

### Prerequisites

1. **Windows Terminal** - Install from [Microsoft Store](https://aka.ms/terminal) or [GitHub](https://github.com/microsoft/terminal)
2. **JetBrains Mono** - Download from [jetbrains.com/lp/mono](https://www.jetbrains.com/lp/mono/)
3. **Oh My Posh** (optional but recommended):
   ```powershell
   winget install JanDeDobbeleer.OhMyPosh
   ```

### Quick Install

1. **Copy settings.json**:
   ```powershell
   # Open Windows Terminal Settings
   # Copy contents of settings.json into your settings
   # Or replace the file at: %LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
   ```

2. **Copy PowerShell Profile**:
   ```powershell
   # Create profile directory if it doesn't exist
   if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
   
   # Add to profile
   Add-Content -Path $PROFILE -Value (Get-Content -Path "Microsoft.PowerShell_profile.ps1" -Raw)
   ```

3. **Copy Oh My Posh Theme**:
   ```powershell
   # Copy theme to Oh My Posh themes folder
   Copy-Item "linkup.omp.json" -Destination "$env:POSH_THEMES_PATH\linkup.omp.json"
   ```

4. **Restart Windows Terminal**

## 🎨 Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Canvas | `#0d1117` | Main background |
| Surface | `#161b22` | Panel background |
| Elevated | `#21262d` | Elevated elements |
| Border | `#30363d` | Borders, dividers |
| Text Primary | `#e6edf3` | Primary text |
| Text Secondary | `#8b949e` | Secondary text |
| Text Tertiary | `#6e7681` | Muted text |
| Accent Blue | `#58a6ff` | Primary accent |
| Accent Dark | `#1f6feb` | Dark accent |
| Success | `#3fb950` | Success states |
| Warning | `#d29922` | Warning states |
| Danger | `#f85149` | Error states |
| Purple | `#a371f7` | Special states |

## 📁 File Structure

```
windows-terminal/
├── settings.json              # Windows Terminal settings
├── Microsoft.PowerShell_profile.ps1  # PowerShell profile
├── linkup.omp.json           # Oh My Posh theme
└── README.md                 # This file
```

## 🖥️ Profiles

### PowerShell
Default PowerShell profile with GitHub Dark theme.

### Command Prompt
Classic command prompt with dark theme.

### Developer Dashboard
Quick access terminal with:
- Current Git branch
- Directory listing
- Development shortcuts

### Git Status
Dedicated Git terminal with:
- Branch information
- Status indicators
- Commit history shortcuts

### Quick Terminal
Minimal terminal with:
- Compact UI
- Dimmed appearance
- Fast startup

## ⌨️ Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Shift+D` | Duplicate pane |
| `Ctrl+Shift+W` | Close pane |
| `Ctrl+T` | New tab (PowerShell) |
| `Ctrl+Shift+T` | New tab (last profile) |
| `Ctrl+Tab` | Next tab |
| `Ctrl+Shift+Tab` | Previous tab |
| `Alt+1-4` | Switch to tab |
| `Ctrl+Shift+]` | Split pane right |
| `Ctrl+Shift++` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |
| `Ctrl+,` | Open settings |
| `F11` | Toggle fullscreen |

## 🎯 Git Integration

The prompt shows:
- **Branch name** - Current Git branch (blue)
- **Status icons** - Staged, modified, untracked
- **Upstream indicators** - Ahead/behind sync status
- **Execution time** - Command execution duration

### Git Shortcuts (in PowerShell)

```powershell
gs          # git status
gst         # git status
gb          # Show current branch
gco <branch>    # git checkout
gcb <branch>    # git checkout -b
gaa         # git add --all
gcm <msg>       # git commit -m
gpush       # git push
gpull       # git pull
glog        # git log --oneline
gdiff       # git diff
gfetch      # git fetch
```

## 🔧 Customization

### Font Settings

```json
"font": {
  "face": "JetBrains Mono",
  "size": 12,
  "weight": "normal",
  "cellWidth": 1.0,
  "cellHeight": 1.0
}
```

### Theme Colors

Edit the `schemes` section in `settings.json` to customize colors.

### Oh My Posh Theme

Edit `linkup.omp.json` to customize the prompt appearance.

### PowerShell Profile

Edit `Microsoft.PowerShell_profile.ps1` to add custom functions and aliases.

## 📋 PowerShell Functions

### Development
```powershell
dev         # Enter dev mode
sysinfo     # Show system info
```

### Git Shortcuts
```powershell
gst         # git status
gco         # git checkout
gaa         # git add --all
gcm         # git commit -m
gpush       # git push
gpull       # git pull
```

### Navigation
```powershell
..          # Go up one directory
...         # Go up two directories
....        # Go up three directories
ll          # List files
la          # List files with details
```

### Node.js
```powershell
ni          # npm install
nis         # npm install --save
nisd        # npm install --save-dev
nr <script>     # npm run
nrb         # npm run build
nrd         # npm run dev
```

### Docker
```powershell
dps         # docker ps
dpsa        # docker ps -a
dstop       # docker stop
drm         # docker rm
dlogs       # docker logs
dexec       # docker exec -it
dsh         # docker exec -it /bin/sh
```

## 🐛 Troubleshooting

### Font not appearing
1. Install JetBrains Mono from [jetbrains.com/lp/mono](https://www.jetbrains.com/lp/mono/)
2. Restart Windows Terminal
3. Verify font is listed in Settings → Appearance → Font

### Oh My Posh not working
1. Install Oh My Posh:
   ```powershell
   winget install JanDeDobbeleer.OhMyPosh
   ```
2. Copy theme:
   ```powershell
   Copy-Item "linkup.omp.json" -Destination "$env:POSH_THEMES_PATH"
   ```
3. Restart terminal

### Acrylic not showing
1. Enable transparency in Settings → Appearance
2. Check if GPU acceleration is enabled
3. Try disabling "Use hardware acceleration"

## 📄 License

Configuration created for LinkUp Studio. Free for personal and commercial use.

---

**Part of LinkUp Studio - Premium Windows Developer Environment**