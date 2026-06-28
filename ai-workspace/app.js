// LinkUp Studio AI Workspace - Main Application

class AIWorkspace {
    constructor() {
        this.currentView = 'chat';
        this.chatHistory = [];
        this.agents = [];
        this.tasks = [];
        this.memory = [];
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupChat();
        this.setupAgents();
        this.setupTasks();
        this.setupMemory();
        this.setupLogs();
        this.setupSettings();
        this.setupCommandPalette();
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.ai-nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const view = item.dataset.view;
                this.switchView(view);
            });
        });
    }

    switchView(viewName) {
        // Update nav
        document.querySelectorAll('.ai-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });

        // Update views
        document.querySelectorAll('.ai-view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });

        this.currentView = viewName;
    }

    // Chat
    setupChat() {
        const chatInput = document.getElementById('chatInput');
        const sendBtn = document.getElementById('sendBtn');
        const clearBtn = document.getElementById('clearChatBtn');

        // Auto-resize textarea
        chatInput?.addEventListener('input', () => {
            chatInput.style.height = 'auto';
            chatInput.style.height = chatInput.scrollHeight + 'px';
        });

        // Send message
        const sendMessage = () => {
            const message = chatInput.value.trim();
            if (message) {
                this.addMessage('user', message);
                chatInput.value = '';
                chatInput.style.height = 'auto';
                
                // Simulate AI response
                setTimeout(() => {
                    this.addMessage('bot', this.generateAIResponse(message));
                }, 1000);
            }
        };

        sendBtn?.addEventListener('click', sendMessage);
        chatInput?.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        // Clear chat
        clearBtn?.addEventListener('click', () => {
            this.clearChat();
        });

        // Suggestions
        document.querySelectorAll('.suggestion-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                chatInput.value = btn.textContent;
                chatInput.focus();
            });
        });
    }

    addMessage(type, text) {
        const messagesContainer = document.getElementById('chatMessages');
        const message = document.createElement('div');
        message.className = `message ${type === 'user' ? 'user' : 'bot'}`;
        
        const time = new Date().toLocaleTimeString('uk-UA', { 
            hour: '2-digit', 
            minute: '2-digit' 
        });

        message.innerHTML = `
            <div class="message-avatar">${type === 'user' ? '👤' : '◎'}</div>
            <div class="message-content">
                <div class="message-text">${this.escapeHtml(text)}</div>
                <div class="message-time">${time}</div>
            </div>
        `;

        messagesContainer.appendChild(message);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;

        this.chatHistory.push({ type, text, time });
    }

    clearChat() {
        const messagesContainer = document.getElementById('chatMessages');
        messagesContainer.innerHTML = `
            <div class="message bot">
                <div class="message-avatar">◎</div>
                <div class="message-content">
                    <div class="message-text">
                        Chat cleared. How can I help you?
                    </div>
                    <div class="message-time">Just now</div>
                </div>
            </div>
        `;
        this.chatHistory = [];
    }

    generateAIResponse(userMessage) {
        const lower = userMessage.toLowerCase();
        
        if (lower.includes('code') || lower.includes('api') || lower.includes('function')) {
            return "I can help you write code! Here's a basic REST API structure:\n\n```javascript\napp.get('/api/users', (req, res) => {\n  res.json({ users: [] });\n});\n```\n\nWould you like me to expand on this?";
        }
        
        if (lower.includes('bug') || lower.includes('error') || lower.includes('fix')) {
            return "I can help debug your code. Please share the error message or the code that's causing issues, and I'll analyze it for you.";
        }
        
        if (lower.includes('review') || lower.includes('pr')) {
            return "I can help with code review! Share the code or PR link, and I'll provide feedback on:\n\n- Code quality\n- Potential bugs\n- Best practices\n- Performance suggestions";
        }
        
        if (lower.includes('doc') || lower.includes('documentation')) {
            return "I can generate documentation for your code. Just share the code or describe what you need documented, and I'll create clear, comprehensive docs.";
        }
        
        return "I'm here to help with your development tasks! I can assist with:\n\n- Writing and refactoring code\n- Debugging issues\n- Code review\n- Documentation\n- And much more!\n\nWhat would you like to work on?";
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML.replace(/\n/g, '<br>');
    }

    // Agents
    setupAgents() {
        document.getElementById('createAgentBtn')?.addEventListener('click', () => {
            this.createAgent();
        });

        document.getElementById('addAgentCard')?.addEventListener('click', () => {
            this.createAgent();
        });
    }

    createAgent() {
        const name = prompt('Agent name:');
        if (name) {
            const type = prompt('Agent type (coder, reviewer, debugger, docs):', 'coder');
            const description = prompt('Description:', `Agent for ${type} tasks`);
            
            this.agents.push({ name, type, description, stats: { tasks: 0, success: 0 } });
            this.renderAgents();
        }
    }

    renderAgents() {
        // Would render agent cards
    }

    // Tasks
    setupTasks() {
        document.getElementById('newTaskBtn')?.addEventListener('click', () => {
            this.createTask();
        });

        document.getElementById('taskFilter')?.addEventListener('change', (e) => {
            this.filterTasks(e.target.value);
        });
    }

    createTask() {
        const name = prompt('Task name:');
        if (name) {
            const task = {
                id: Date.now(),
                name,
                agent: 'Coder Agent',
                status: 'pending',
                progress: 0,
                created: new Date()
            };
            this.tasks.push(task);
            this.renderTasks();
        }
    }

    filterTasks(filter) {
        const taskItems = document.querySelectorAll('.task-item');
        taskItems.forEach(item => {
            if (filter === 'all') {
                item.style.display = 'flex';
            } else {
                // Filter logic based on task status
                item.style.display = 'flex';
            }
        });
    }

    renderTasks() {
        // Would render task list
    }

    // Memory
    setupMemory() {
        document.querySelectorAll('.category-item').forEach(item => {
            item.addEventListener('click', () => {
                this.filterMemory(item.dataset.category);
            });
        });
    }

    filterMemory(category) {
        document.querySelectorAll('.category-item').forEach(item => {
            item.classList.toggle('active', item.dataset.category === category);
        });

        const memoryItems = document.querySelectorAll('.memory-item');
        memoryItems.forEach(item => {
            if (category === 'all') {
                item.style.display = 'flex';
            } else {
                const type = item.querySelector('.memory-type').textContent.toLowerCase();
                item.style.display = type === category ? 'flex' : 'none';
            }
        });
    }

    // Logs
    setupLogs() {
        document.getElementById('clearLogsBtn')?.addEventListener('click', () => {
            this.clearLogs();
        });

        document.getElementById('downloadLogsBtn')?.addEventListener('click', () => {
            this.downloadLogs();
        });

        document.getElementById('logLevel')?.addEventListener('change', (e) => {
            this.filterLogs(e.target.value);
        });
    }

    clearLogs() {
        const logsList = document.getElementById('logsList');
        if (logsList) {
            logsList.innerHTML = '';
        }
    }

    downloadLogs() {
        const logs = Array.from(document.querySelectorAll('.log-item')).map(log => {
            return {
                time: log.querySelector('.log-time')?.textContent,
                level: log.querySelector('.log-level')?.textContent,
                source: log.querySelector('.log-source')?.textContent,
                message: log.querySelector('.log-message')?.textContent
            };
        });

        const blob = new Blob([JSON.stringify(logs, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `ai-logs-${new Date().toISOString().split('T')[0]}.json`;
        a.click();
        URL.revokeObjectURL(url);
    }

    filterLogs(level) {
        const logItems = document.querySelectorAll('.log-item');
        logItems.forEach(item => {
            if (level === 'all') {
                item.style.display = 'flex';
            } else {
                item.style.display = item.classList.contains(level) ? 'flex' : 'none';
            }
        });
    }

    // Settings
    setupSettings() {
        // Settings are UI only for demo
    }

    // Command Palette
    setupCommandPalette() {
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                this.showCommandPalette();
            }
            if (e.key === 'Escape') {
                this.hideCommandPalette();
            }
        });
    }

    showCommandPalette() {
        const palette = document.getElementById('commandPalette');
        if (palette) {
            palette.classList.add('visible');
            document.getElementById('paletteInput')?.focus();
        }
    }

    hideCommandPalette() {
        const palette = document.getElementById('commandPalette');
        if (palette) {
            palette.classList.remove('visible');
        }
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.aiWorkspace = new AIWorkspace();
});
