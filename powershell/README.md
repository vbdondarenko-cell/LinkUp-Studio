# LinkUp Studio Premium PowerShell Experience

A professional IDE-style PowerShell experience with GitHub Dark theme, Git integration, and developer tools.

## ✨ Features

- **IDE-Style Startup Banner** - Beautiful LinkUp Studio ASCII art banner
- **Repository Information Panel** - Current repo, branch, status, stashes
- **System Information Panel** - Time, PowerShell version, OS, RAM, uptime
- **GitHub Dark Color Scheme** - Professional dark theme throughout
- **Quick Commands Panel** - Common shortcuts reference
- **Developer Shortcuts** - Git, Node.js, Docker, Python shortcuts

## 📊 Display Examples

### Startup Banner
```
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║    ██╗    ██╗  ██████╗  ██████╗  ██████╗     ███╗   ███╗ ██████╗ ██████╗  ██████╗      ║
║    ██║    ██║ ██╔════╝ ██╔════╝ ██╔═══██╗    ████╗ ████║██╔═══██╗██╔══██╗██╔═══██╗     ║
║    ██║ █╗ ██║ ██║  ███╗██║  ███╗██║   ██║    ██╔████╔██║██║   ██║██║  ██║██║   ██║     ║
║    ██║███╗██║ ██║   ██║██║   ██║██║   ██║    ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║     ║
║    ╚██████╔╝ ╚██████╔╝╚██████╔╝╚██████╔╝    ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝     ║
║     ╚═══██╔╝   ╚═════╝  ╚═════╝  ╚═════╝     ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝      ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
```

### Repository Panel
```
┌──────────────────────────────────────────────────────────────────────────────┐
│  REPOSITORY INFORMATION                                                       │
├──────────────────────────────────────────────────────────────────────────────┤
│  Repository    LinkUp-Studio                                                   │
│  Path          C:\Users\Dev\Projects\LinkUp-Studio                            │
│  Branch        main                                                           │
│  Status        Clean                                                          │
└──────────────────────────────────────────────────────────────────────────────┘
```

### System Panel
```
┌──────────────────────────────────────────────────────────────────────────────┐
│  SYSTEM INFORMATION                                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│  Current Time  2024-01-15 14:32:45                                            │
│  PowerShell    v7.4.1 (Core)                                                  │
│  Computer      DEV-PC (Developer)                                             │
│  OS            Windows 11 Pro                                                 │
│  Memory        32 GB RAM                                                       │
│  Uptime        2d 5h 32m                                                       │
└──────────────────────────────────────────────────────────────────────────────┘
```

## 🎨 Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Banner | Cyan | `#39c5cf` |
| Primary Text | Light | `#e6edf3` |
| Secondary Text | Gray | `#8b949e` |
| Branch | Blue | `#58a6ff` |
| Staged | Green | `#3fb950` |
| Modified | Yellow | `#d29922` |
| Errors | Red | `#f85149` |
| Special | Purple | `#a371f7` |
| Borders | Gray | `#484f58` |

## 🚀 Installation

### Quick Install

```powershell
# Download and run installer
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/vbdondarenko-cell/LinkUp-Studio/main/powershell/install.ps1" | Invoke-Expression
```

### Manual Install

1. **Create profile directory if needed:**
```powershell
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -ItemType File -Force }
```

2. **Add to your profile:**
```powershell
# Add this line to your $PROFILE
. "C:\path\to\Microsoft.PowerShell_profile.ps1"
```

Or copy the file to your PowerShell profile location.

## 📋 Available Functions

### Development Commands
```powershell
dev         # Show developer dashboard (refresh with refresh)
sysinfo     # Show detailed system information
sys         # Alias for sysinfo
```

### Navigation
```powershell
..          # Go up one directory
...         # Go up two directories
....        # Go up three directories
~           # Go to home directory
ll          # List files with details
la          # List all files
```

### Git Shortcuts
```powershell
gst         # git status
gs          # alias for gst
gco <branch>    # git checkout
gcb <branch>    # git checkout -b (new branch)
gaa         # git add --all
gcm <msg>       # git commit -m
gpush       # git push
gpull       # git pull
gpll        # git pull --rebase
glog        # git log with graph
gdiff       # git diff
gdiffc      # git diff --cached
gfetch      # git fetch --all
gstash      # git stash
gstashp     # git stash pop
gbranch     # git branch -a
gremote     # git remote -v
gconf       # git config --list
```

### Node.js Shortcuts
```powershell
ni          # npm install
nis         # npm install --save
nisd        # npm install --save-dev
nr <script>     # npm run <script>
nrt         # npm run test
nrw         # npm run watch
nrb         # npm run build
nrd         # npm run dev
nidi        # npm init -y
nirl        # npm info <package>
nild        # npm list
niout       # npm outdated
```

### Python Shortcuts
```powershell
pa          # python <file>
pa3         # python3 <file>
pipi        # pip install
pip3i       # pip3 install
pact        # python -m venv + activate
pyd         # python -m http.server
```

### Docker Shortcuts
```powershell
dps         # docker ps
dpsa        # docker ps -a
dstop       # docker stop <container>
drm         # docker rm <container>
drmi        # docker rmi <image>
dlogs       # docker logs <container>
dexec       # docker exec -it <container>
dsh         # docker exec -it <container> /bin/sh
dib         # docker build -t <name>
drun        # docker run -it <image>
dnet        # docker network ls
dvol        # docker volume ls
dclean      # docker system prune -af
```

## 🔧 Configuration

### Customizing Colors
Edit the `$Colors` hashtable at the top of the profile:

```powershell
$Colors = @{
    Canvas         = "#0d1117"
    Surface        = "#161b22"
    AccentBlue     = "#58a6ff"
    Success        = "#3fb950"
    # ... more colors
}
```

### Disabling Oh My Posh
If you don't want Oh My Posh, the profile will work without it:

```powershell
# Just remove or comment out the Oh My Posh section:
# try {
#     if (Get-Command oh-my-posh -errorAction SilentlyContinue) {
#         # ... initialization
#     }
# } catch { }
```

## 📁 File Structure

```
powershell/
├── Microsoft.PowerShell_profile.ps1   # Main profile
├── install.ps1                        # Installer script
└── README.md                          # This file
```

## 🖥️ Requirements

- **PowerShell 5.1+** or **PowerShell 7+**
- **Windows 10/11** or **Windows Server 2019+**
- **Git** (for Git integration features)
- **Optional:** Oh My Posh for enhanced prompt

## 📄 License

Created for LinkUp Studio. Free for personal and commercial use.

---

**Part of LinkUp Studio - Premium Windows Developer Environment**