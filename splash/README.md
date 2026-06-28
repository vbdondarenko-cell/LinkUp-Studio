# LinkUp Studio Splash Screen

Beautiful loading screen with GitHub Dark theme for LinkUp Studio.

## Features

- 🎨 **GitHub Dark Theme** - Consistent with LinkUp Studio design
- ✨ **Smooth Animations** - Logo reveal, loading bar, fade transitions
- 📊 **Progress Tracking** - Visual feedback during initialization
- ⌨️ **Keyboard Hints** - Show shortcuts while loading
- 🌐 **Web-Based** - Runs in any modern browser

## Files

| File | Description |
|------|-------------|
| `index.html` | Main splash screen (standalone HTML) |
| `README.md` | This file |

## Usage

### As Standalone

Open `index.html` in any browser to preview the splash screen.

### As Windows Terminal Animation

The splash can be displayed in Windows Terminal when it starts:

```powershell
# Add to your PowerShell profile
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║                                                   ║" -ForegroundColor Cyan
Write-Host "  ║       L I N K U P   S T U D I O                 ║" -ForegroundColor Cyan
Write-Host "  ║       Developer Workspace v1.0                   ║" -ForegroundColor DarkGray
Write-Host "  ║                                                   ║" -ForegroundColor Cyan
Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
```

### As Browser Startup Page

Set as your browser's homepage/new tab for a branded experience.

## Customization

### Change Colors

Edit CSS variables:
```css
:root {
  --bg-canvas: #0d1117;      /* Background */
  --accent-blue: #58a6ff;    /* Primary accent */
  --accent-purple: #a371f7;  /* Secondary accent */
}
```

### Change Timing

```javascript
// Adjust animation duration
const interval = setInterval(() => {
  // ... timing logic
}, 400); // Change 400ms to adjust speed
```

### Change Status Messages

```javascript
const messages = [
  { progress: 0, text: 'Initializing...' },
  { progress: 100, text: 'Ready!' }
];
```

## Integration

### With Startup Script

Add to `startup.ps1`:
```powershell
# Show splash in terminal
Write-Host ""
Write-Host "  LinkUp Studio v2.0 - Loading..." -ForegroundColor Cyan
Write-Host ""
```

### With Installer

The installer can display the splash during setup:
```powershell
# In install script
Start-Process "path/to/splash/index.html"
```

## Browser Compatibility

- ✅ Chrome 80+
- ✅ Edge 80+
- ✅ Firefox 75+
- ✅ Safari 13+

## License

MIT - See main repository