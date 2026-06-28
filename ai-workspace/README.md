# LinkUp Studio - AI Workspace

A comprehensive AI-powered workspace for developers, integrated with OpenHands.

## Features

### 🤖 AI Chat
- Real-time chat with OpenHands
- Code suggestions and completions
- Context-aware responses
- Quick action suggestions
- Chat history

### 👥 AI Agents
- **Coder Agent** - Write and refactor code
- **Review Agent** - Code review and analysis
- **Debugger Agent** - Find and fix bugs
- **Docs Agent** - Generate documentation
- Agent statistics and status
- Create custom agents

### 📋 AI Tasks
- Task queue management
- Progress tracking
- Task status (pending, running, completed, failed)
- Agent assignment
- Task history

### 🧠 AI Memory
- Persistent knowledge storage
- Categories: Code, Documents, Projects, Concepts
- Search functionality
- Relevance scoring
- Auto-save intervals

### 📜 AI Logs
- Real-time log viewer
- Log levels: Info, Warning, Error
- Log sources: Chat, Agent, Task, System
- Filter and search
- Export logs

### ⚙️ AI Settings
- OpenHands connection settings
- Model configuration
- Agent settings
- Memory settings
- Notifications

## Design

- GitHub Dark theme
- Modern chat interface
- Status indicators
- Progress bars
- Command palette (Ctrl+K)

## Architecture

```
ai-workspace/
├── index.html     # Main HTML structure
├── styles.css     # GitHub Dark styling
├── app.js         # Application logic
└── README.md      # Documentation
```

## Usage

Open `index.html` in a browser for demo, or integrate with OpenHands API for full functionality.

## OpenHands Integration

Connect to OpenHands at: `https://app.all-hands.dev`

Configure API key in Settings to enable full AI capabilities.

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+K | Command Palette |
| Enter | Send message |
| Shift+Enter | New line in chat |
| Escape | Close palette |

## Future Features

- [ ] Real OpenHands API integration
- [ ] Agent customization
- [ ] Task scheduling
- [ ] Memory sync
- [ ] Multi-user support
