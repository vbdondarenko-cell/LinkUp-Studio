# LinkUp Studio - Project Manager

A comprehensive project management interface for developers with GitHub integration, templates, and favorites.

## Features

### 📂 Project Management
- **All Projects** - View all projects in grid or list
- **Recent Projects** - Quick access to recently opened
- **Favorites** - Star projects for quick access
- Project cards with Git info, last modified

### 🔗 GitHub Integration
- Branch display
- Commit count
- Repository sync status

### 📋 Repositories
- GitHub repository list
- Quick access to repositories
- Add new repositories

### 📐 Templates
- **Node.js Express** - Backend API template
- **Python Flask** - Python web template
- **React App** - Frontend React template
- **VS Code Extension** - Extension development

### ⌨️ Keyboard Shortcuts
| Shortcut | Action |
|----------|--------|
| Ctrl+P | Search projects |
| Ctrl+N | New project |
| Escape | Clear search |

### 🎨 Design
- GitHub Dark theme
- Grid and list views
- Project type icons (Node, Python, React, Docker)
- Status indicators

## Architecture

```
project-manager/
├── index.html     # Main HTML structure
├── styles.css     # GitHub Dark styling
├── app.js         # Application logic
└── README.md      # Documentation
```

## Usage

Open `index.html` in a browser.

### Actions
- Click project card to open
- Star button to add to favorites
- VS Code button to open in editor
- Terminal button to open terminal

## Future Features

- [ ] Real file system access
- [ ] Git operations (clone, pull, push)
- [ ] Project templates
- [ ] GitHub API integration
- [ ] Remote project management
