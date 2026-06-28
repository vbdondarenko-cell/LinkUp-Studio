# LinkUp Studio Wallpapers

## Overview

This folder contains high-quality dark wallpapers designed for the LinkUp Studio experience.

## Included Wallpapers

| File | Resolution | Description |
|------|-----------|-------------|
| `github-dark.png` | 1920x1080 | GitHub Dark default wallpaper |
| `github-dark-4k.png` | 3840x2160 | 4K version |

## Wallpaper Specifications

### Design
- **Theme**: GitHub Dark
- **Colors**: 
  - Primary: #0D1117 (Canvas)
  - Accent: #58A6FF (GitHub Blue)
  - Secondary: #161B22 (Surface)
- **Style**: Minimal, geometric, modern
- **Format**: PNG with transparency support

### Sizes
- 1920x1080 (Full HD)
- 2560x1440 (2K)
- 3840x2160 (4K)
- 5120x2880 (5K)

## Installation

### Method 1: Right-Click
1. Right-click on the wallpaper image
2. Select "Set as desktop background"

### Method 2: Settings
1. Open Windows Settings → Personalization → Background
2. Select "Picture"
3. Browse to this folder
4. Select wallpaper
5. Choose "Fill" or "Fit"

### Method 3: PowerShell
```powershell
$wallpaper = "Path\to\LinkUp-Studio\windows-experience\wallpapers\github-dark.png"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaper
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value 10
```

## Custom Wallpapers

### Creating Your Own

1. Use the color palette from LinkUp Studio design system
2. Recommended colors:
   - Background: #0D1117
   - Accent: #58A6FF
   - Surface: #161B22
   - Border: #30363D
   - Text: #E6EDF3

### Tools
- Figma (recommended)
- Photoshop
- Affinity Designer
- GIMP (free)

### Tips
- Keep it simple and minimal
- Use subtle gradients
- Add geometric shapes for visual interest
- Include LinkUp Studio logo elements

## Wallpaper Slideshow

To create a wallpaper slideshow:

1. Create a folder with multiple wallpapers
2. Right-click desktop → Personalize
3. Background → Slideshow
4. Browse to folder
5. Choose change frequency

## Recommended Settings

### Display Settings
- **Fit**: Fill (for most monitors)
- **Color**: sRGB (for accuracy)

### Night Light
Enable Night Light for a warmer appearance:
1. Settings → Display → Night light
2. Turn on Night light
3. Adjust color temperature

## Uninstalling Wallpapers

1. Right-click desktop → Personalize
2. Select a different wallpaper
3. Or use the Uninstall script

## Credits

Wallpapers designed for LinkUp Studio.
Inspired by GitHub Dark theme.
