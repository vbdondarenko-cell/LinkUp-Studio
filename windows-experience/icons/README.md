# LinkUp Studio Windows Icons

## Overview

This folder contains custom icons for LinkUp Studio Windows experience. These icons replace default Windows icons with a premium GitHub Dark-themed design.

## Included SVG Icons

| Icon | File | Description |
|------|------|-------------|
| LinkUp Studio | `linkup-studio.svg` | Main app icon with logo |
| Folder | `folder.svg` | Custom folder icon |
| Terminal | `terminal.svg` | Terminal window icon |
| Code | `code.svg` | Code brackets icon |

## Quick Install

```powershell
# Run as Administrator
.\Install-Icons.ps1

# Create desktop shortcuts
.\Install-Icons.ps1 -Shortcuts
```

## Desktop Icons

The following icons are designed for desktop shortcuts:

| Icon | File | Description |
|------|------|-------------|
| Computer | `ThisPC.ico` | System/This PC icon |
| Downloads | `Downloads.ico` | Downloads folder |
| Documents | `Documents.ico` | Documents folder |
| Projects | `Projects.ico` | Custom developer projects |
| GitHub | `GitHub.ico` | GitHub Desktop/Website |
| LinkUp Studio | `LinkUpStudio.ico` | Main application |
| Terminal | `Terminal.ico` | Windows Terminal |
| VS Code | `VSCode.ico` | Visual Studio Code |
| OpenHands | `OpenHands.ico` | OpenHands AI Assistant |
| Recycle Bin | `RecycleBin.ico` | Recycle Bin (empty) |

## File Type Icons

Icons for common developer file types:

| Extension | Icon File | Description |
|----------|-----------|-------------|
| `.ts` | `TypeScript.ico` | TypeScript files |
| `.tsx` | `TypeScriptReact.ico` | TypeScript React files |
| `.js` | `JavaScript.ico` | JavaScript files |
| `.jsx` | `JavaScriptReact.ico` | JavaScript React files |
| `.md` | `Markdown.ico` | Markdown files |
| `.json` | `JSON.ico` | JSON files |
| `.sql` | `SQL.ico` | SQL files |
| `.env` | `EnvFile.ico` | Environment files |
| `.yml` / `.yaml` | `YAML.ico` | YAML files |
| `.gitignore` | `GitIgnore.ico` | Git ignore files |
| `README` | `Readme.ico` | README files |

## Installation

### Desktop Icons

#### Method 1: Right-Click Desktop
1. Right-click on desktop → Personalize
2. Click "Themes" → "Desktop icon settings"
3. Click "Change Icon..."
4. Browse to this folder and select icon
5. Click OK → Apply

#### Method 2: Shortcut Properties
1. Right-click any shortcut
2. Click "Properties" → "Change Icon..."
3. Browse to this folder
4. Select icon → OK

### File Type Icons (Safe Method)

Use the PowerShell script for safe icon installation:

```powershell
# Run as Administrator
.\Install-FileIcons.ps1
```

### Folder Icons

#### Method 1: Folder Properties
1. Right-click folder → Properties
2. Click "Customize" tab
3. Click "Change Icon..."
4. Browse to this folder
5. Select folder icon → OK

#### Method 2: PowerShell
```powershell
# Change a folder's icon
$folderPath = "C:\Path\To\Folder"
$iconPath = "$PSScriptRoot\Folder.ico"

# Set folder icon (via desktop.ini)
$iniContent = @"
[.ShellClassInfo]
IconResource=$iconPath,0
"@

$iniPath = Join-Path $folderPath "desktop.ini"
Set-Content -Path $iniPath -Value $iniContent -Encoding Unicode
attrib +S +H $iniPath
```

## Recommended Folder Organization

Create these folders with custom icons:

```
C:\Users\<username>\
├── Projects\           # Your coding projects
├── Repositories\       # Git repositories
├── AI\                # AI/ML projects
├── Design\            # Design files
├── Scripts\           # Utility scripts
├── Tools\             # Development tools
├── Archives\          # Archived projects
└── Downloads\         # Downloads (already has icon)
```

## Icon Specifications

### Sizes
- 16x16 - Toolbar icons
- 32x32 - Desktop icons (small)
- 48x48 - Desktop icons (large)
- 256x256 - High-resolution display

### Format
- ICO format for Windows compatibility
- PNG embedded for quality
- Multiple sizes in single file

## Design Guidelines

All icons follow the LinkUp Studio design system:
- **Color palette**: GitHub Dark (#0D1117, #161B22, #58A6FF)
- **Stroke width**: 1.5px consistent
- **Corner radius**: Rounded corners
- **Style**: Minimal, outline-based

## Uninstall Icons

To restore default Windows icons:

1. Right-click desktop → Personalize
2. Themes → Desktop icon settings
3. Click "Restore Default"
4. For file icons, use the uninstall script:
```powershell
.\Uninstall-FileIcons.ps1
```

## Notes

- **Safe**: Only modifies user-level icons
- **Reversible**: Default icons can be restored
- **Non-destructive**: Original icons preserved in backup
- **No system files**: All changes are user-scope

## Credits

Icons designed for LinkUp Studio.
Based on GitHub, Linear, and Arc Browser iconography.
