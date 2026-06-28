# LinkUp Studio Shell

A complete Windows Shell replacement for developers - built with modern design and GitHub Dark theme.

## Features

### Window Management
- **Tab-based interface** - Multiple tabs for different workspaces
- **Minimize, Maximize, Close** - Standard window controls
- **Sidebar panels** - Explorer, Search, Git, Extensions

### Menu System
- **File Menu** - New Window, Open Project, Save, Settings, Exit
- **Edit Menu** - Undo, Redo, Cut, Copy, Paste, Find
- **View Menu** - Toggle Sidebar, Terminal, Fullscreen
- **Terminal Menu** - New Terminal, Split, Clear
- **Window Menu** - Minimize, Maximize, Close, Next/Prev
- **Help Menu** - About, Documentation, Keyboard Shortcuts

### Sidebar Panels
- **Explorer** - File tree navigation
- **Search** - Global search
- **Git** - Source control changes
- **Extensions** - Plugin management

### Dashboard
- Quick Actions grid
- Recent Projects list
- System Information (CPU, RAM, Disk)
- Git Status

### Control Center
- Wi-Fi toggle
- Bluetooth toggle
- Airplane Mode
- Night Light
- Brightness slider
- Volume slider
- Quick actions (OpenHands, Settings)

### Terminal
- Integrated terminal panel
- Multiple terminal tabs
- Terminal split

### Status Bar
- Git branch and sync status
- Cursor position
- File encoding
- Language mode
- Notifications
- Clock

## Design

- **GitHub Dark** color scheme
- **VS Code-inspired** layout
- **Windows 11** style controls
- **JetBrains Mono** font for code

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+N | New Window |
| Ctrl+T | New Tab |
| Ctrl+W | Close Tab |
| Ctrl+B | Toggle Sidebar |
| Ctrl+` | Toggle Terminal |
| F11 | Fullscreen |
| Alt+F4 | Close Window |
| Ctrl+, | Settings |

## Architecture

```
shell/
├── index.html     # Main HTML structure
├── styles.css     # GitHub Dark styling
├── app.js         # Application logic
└── README.md      # Documentation
```

## Usage

Open `index.html` in a browser for demo, or in Electron/Tauri for full functionality.

## Future Features

- [ ] Real file system access
- [ ] Terminal emulation
- [ ] Git integration
- [ ] Docker management
- [ ] Database connections
- [ ] Plugin system
