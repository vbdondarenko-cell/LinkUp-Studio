# LinkUp Studio Launcher

A beautiful dashboard and launcher for LinkUp Studio - your premium developer workspace.

## Features

- **Dashboard** - Quick overview with system status, recent projects, and git activity
- **Sidebar Navigation** - Easy access to all sections
- **Search/Command Palette** - Ctrl+K to quickly find apps and run commands
- **Quick Actions** - Launch terminal, GitHub, OpenHands with one click
- **Project Management** - Add and manage your projects
- **GitHub Integration** - View repositories and activity
- **AI Assistant** - Quick access to OpenHands
- **Settings** - Customize your workspace

## Design

- GitHub Dark theme
- Modern, clean UI
- Responsive layout
- Keyboard shortcuts

## Usage

Open `index.html` in a browser to test the launcher.

For full functionality (opening apps, running commands), this launcher is designed to run as:

1. **Windows App** - Using Electron or Tauri
2. **Web App** - With backend API
3. **Browser Extension** - Chrome/Firefox extension

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+K | Open search/command palette |
| Escape | Close command palette |

## Sections

### Dashboard
- Quick actions grid
- Recent projects list
- System status indicators
- Git activity info

### Apps
- Grid of installed applications
- Quick launch on click

### Projects
- Project cards with name and path
- Add new projects
- Open projects in VS Code

### GitHub
- Repository list
- Recent activity feed

### AI
- OpenHands launch button
- AI quick actions (Code Review, Bug Detection, etc.)

### Settings
- Theme selection
- Startup options
- Terminal configuration

## Configuration

Settings are stored in `localStorage`:
- Theme preference
- Launch on startup
- Open last project
- Default shell

Projects are stored in `localStorage` as JSON array.

## Future Enhancements

- Real file system access
- Terminal emulation
- Git integration via libgit2
- Docker management
- Database connections
