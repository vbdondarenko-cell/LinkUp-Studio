# LinkUp Studio Startup Configuration

Configure LinkUp Studio to launch automatically after Windows login in under 10 seconds.

## Features

- ⚡ **Fast Startup** - Optimized for < 10 second startup time
- 🔄 **Parallel Launch** - Apps launch simultaneously, not sequentially
- 🎯 **Smart Detection** - Auto-detects OpenHands installation
- ⚙️ **Configurable** - Customize URLs, project paths, and delays
- 🔒 **Safe** - Creates backups and logs all actions

## Startup Sequence

```
0.0s ────────────────────────────────────────────────────────────────────
       [Login Complete]
       
0.1s ────────────────────────────────────────────────────────────────────
       ┌─────────────────────────────┐
       │  Windows Terminal           │ ← Launched immediately
       │  (LinkUp Studio Profile)   │
       └─────────────────────────────┘
       
0.2s ────────────────────────────────────────────────────────────────────
       ┌─────────────────────────────┐
       │  OpenHands                  │ ← Parallel launch
       └─────────────────────────────┘
       
0.5s ────────────────────────────────────────────────────────────────────
       [Service Stabilization]       ← Wait 500ms for services
       
0.6s ────────────────────────────────────────────────────────────────────
       ┌─────────────────────────────┐
       │  Browser                    │ ← Open app.all-hands.dev
       │  (Edge/Default)            │
       └─────────────────────────────┘
       
0.8s ────────────────────────────────────────────────────────────────────
       ┌─────────────────────────────┐
       │  Previous Project           │ ← If configured
       │  (Optional)                │
       └─────────────────────────────┘

9.9s ────────────────────────────────────────────────────────────────────
       [All Apps Ready]
```

## Quick Start

### One-Click Setup

```powershell
# Download and run
git clone https://github.com/vbdondarenko-cell/LinkUp-Studio.git
cd LinkUp-Studio\installer\startup
.\OneClick-StartupSetup.bat
```

### Manual Setup

```powershell
# Run as Administrator
.\Configure-Startup.ps1
```

## Usage

### Interactive Setup

```powershell
.\Configure-Startup.ps1
```

This will prompt for:
1. OpenHands path (auto-detected if installed)
2. Browser URL (default: https://app.all-hands.dev)
3. Project path (optional)
4. Wait for services (default: yes)

### Enable Startup

```powershell
# With custom settings
.\Configure-Startup.ps1 -Enable `
    -BrowserURL "https://app.all-hands.dev" `
    -ProjectPath "C:\Projects\MyProject"

# With defaults
.\Configure-Startup.ps1 -Enable
```

### Disable Startup

```powershell
.\Configure-Startup.ps1 -Disable
```

### Check Status

```powershell
.\Configure-Startup.ps1 -Status
```

## Configuration Options

### Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-Enable` | Enable startup | - |
| `-Disable` | Disable startup | - |
| `-Status` | Show current status | - |
| `-BrowserURL` | URL to open in browser | `https://app.all-hands.dev` |
| `-ProjectPath` | Project folder to open | (none) |
| `-OpenHandsPath` | Custom OpenHands path | (auto-detect) |
| `-WaitForServices` | Wait before browser | `true` |
| `-Silent` | Suppress output | `false` |

### Configuration File

Settings are saved to: `%LOCALAPPDATA%\LinkUpStudio\startup_config.json`

```json
{
    "Enabled": true,
    "BrowserURL": "https://app.all-hands.dev",
    "ProjectPath": "C:\\Projects\\MyProject",
    "OpenHandsPath": "C:\\Program Files\\OpenHands\\openhands.exe",
    "WaitForServices": true,
    "ConfiguredAt": "2024-01-15 10:30:00",
    "MaxStartupTime": 10
}
```

## Startup Behavior

### What Gets Launched

1. **Windows Terminal** with LinkUp Studio profile (maximized)
2. **OpenHands** application (if installed)
3. **Browser** at configured URL (after 500ms)
4. **Previous project** in new terminal tab (if configured)

### Service Wait

The 500ms delay before opening the browser ensures:
- Windows Terminal is fully loaded
- Terminal services are ready
- Shell extensions are initialized
- Font rendering is complete

### OpenHands Detection

The script auto-detects OpenHands from these locations:
```
%LOCALAPPDATA%\Programs\open-hands\openhands.exe
%LOCALAPPDATA%\open-hands\openhands.exe
%ProgramFiles%\OpenHands\openhands.exe
%APPDATA%\OpenHands\openhands.exe
```

## Troubleshooting

### Startup Not Working

1. Check if shortcut exists in Startup folder:
   ```
   %APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
   ```

2. Check startup log:
   ```
   %LOCALAPPDATA%\LinkUpStudio\startup.log
   ```

3. Manually run the startup script:
   ```powershell
   %LOCALAPPDATA%\LinkUpStudio\LinkUp-Studio-Startup.ps1
   ```

### Apps Launching Too Slow

1. Disable `-WaitForServices`:
   ```powershell
   .\Configure-Startup.ps1 -Enable -WaitForServices:$false
   ```

2. Reduce browser wait in startup script (edit line 99):
   ```powershell
   Start-Sleep -Milliseconds 200  # Reduce from 500
   ```

### Browser Not Opening

1. Check default browser is set:
   ```powershell
   start ms-edge:settings
   ```

2. Use explicit browser path in configuration

### OpenHands Not Launching

1. Verify OpenHands is installed:
   ```powershell
   Get-ChildItem -Path "$env:LOCALAPPDATA" -Recurse -Filter "openhands*.exe" -ErrorAction SilentlyContinue
   ```

2. Manually specify path:
   ```powershell
   .\Configure-Startup.ps1 -Enable -OpenHandsPath "C:\Path\To\openhands.exe"
   ```

## Performance Optimization

### For Faster Startup (< 5 seconds)

1. Use `-WaitForServices:$false`
2. Disable browser startup
3. Use SSD for Windows installation
4. Disable unnecessary startup programs

### Recommended Settings

```powershell
.\Configure-Startup.ps1 -Enable `
    -BrowserURL "https://app.all-hands.dev" `
    -WaitForServices $true
```

### Startup Time Targets

| Configuration | Expected Time |
|---------------|---------------|
| Minimal (Terminal only) | 2-3 seconds |
| Standard (Terminal + Browser) | 4-6 seconds |
| Full (All apps) | 6-8 seconds |
| With service wait | +0.5 seconds |

## Files

```
%LOCALAPPDATA%\LinkUpStudio\
├── startup_config.json          # Configuration
├── startup.log                  # Startup log
├── LinkUp-Studio-Startup.ps1    # Main startup script
└── startup.ps1                  # User startup script

%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\
└── LinkUp Studio.lnk            # Windows startup shortcut
```

## Uninstallation

### Remove from Startup

```powershell
.\Configure-Startup.ps1 -Disable
```

### Remove All Files

```powershell
# Remove startup shortcut
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\LinkUp Studio.lnk"

# Remove LinkUp Studio config
Remove-Item "$env:LOCALAPPDATA\LinkUpStudio" -Recurse -Force
```

## Integration with Main Installer

The startup configuration can be integrated with the main LinkUp Studio installer:

```powershell
# In main installer, add this line:
.\Configure-Startup.ps1 -Enable -BrowserURL $UserConfig.BrowserURL -ProjectPath $UserConfig.ProjectPath
```

## License

MIT License - See main repository for details.
