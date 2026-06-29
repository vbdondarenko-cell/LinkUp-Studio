# LinkUp Studio - Workspace Restore

A session management and workspace restore system for developers.

## Features

### 💾 Session Management
- **Save Sessions** - Save current workspace state
- **Restore Sessions** - Restore saved sessions with one click
- **Auto-save** - Automatically save sessions periodically
- **Session History** - Track all session changes

### 📊 Current Session
- Real-time view of active components
- Projects count
- Terminal tabs
- Browser tabs
- OpenHands sessions
- Docker containers

### ⏱️ Timeline History
- Chronological session history
- Session start/end events
- Project additions
- Automatic grouping by day/week

### ⚙️ Settings
- **Auto-Restore** - Restore last session on startup
- **Auto-Save** - Configurable auto-save interval
- **Application Restore** - Choose what to restore
- **Data Management** - Storage location and cleanup

## Architecture

```
workspace-restore/
├── index.html     # Main HTML structure
├── styles.css     # GitHub Dark styling
├── app.js         # Application logic
└── README.md      # Documentation
```

## Usage

### Saving a Session
1. Click "Save Current Session"
2. Enter session name
3. Session is saved with all open components

### Restoring a Session
1. Select a saved session
2. Click "Restore"
3. Confirm in modal
4. Workspace is restored

### Auto-save
- Automatically saves every 15 minutes
- Keeps last 10 auto-saved sessions
- Toggle on/off in header

## Components Saved

- VS Code projects
- Terminal tabs and directories
- Browser tabs and URLs
- OpenHands conversations
- Docker containers
- Database connections

## Future Features

- [ ] Real application integration
- [ ] Cloud sync
- [ ] Session comparison
- [ ] Session templates
- [ ] Scheduled restores
