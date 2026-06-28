// LinkUp Studio Launcher - Main Application

class LinkUpLauncher {
    constructor() {
        this.currentView = 'dashboard';
        this.projects = [];
        this.settings = this.loadSettings();
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupSearch();
        this.setupQuickActions();
        this.setupCommandPalette();
        this.loadProjects();
        this.loadGitInfo();
        this.checkSystemStatus();
        this.setupSettings();
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const view = item.dataset.view;
                this.switchView(view);
            });
        });
    }

    switchView(viewName) {
        // Update nav items
        document.querySelectorAll('.nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });

        // Update views
        document.querySelectorAll('.view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });

        this.currentView = viewName;
    }

    // Search
    setupSearch() {
        const searchInput = document.getElementById('searchInput');
        
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            if (query.length > 0) {
                this.showCommandPalette(query);
            } else {
                this.hideCommandPalette();
            }
        });

        searchInput.addEventListener('focus', () => {
            if (searchInput.value) {
                this.showCommandPalette(searchInput.value);
            }
        });

        // Keyboard shortcut
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                searchInput.focus();
            }
            if (e.key === 'Escape') {
                this.hideCommandPalette();
                searchInput.blur();
            }
        });
    }

    // Quick Actions
    setupQuickActions() {
        const quickActions = document.querySelectorAll('.quick-action');
        quickActions.forEach(action => {
            action.addEventListener('click', () => {
                const actionType = action.dataset.action;
                this.executeAction(actionType);
            });
        });

        // Header action buttons
        document.getElementById('terminalBtn')?.addEventListener('click', () => this.openTerminal());
        document.getElementById('githubBtn')?.addEventListener('click', () => this.openGitHub());
        document.getElementById('openhandsBtn')?.addEventListener('click', () => this.openOpenHands());
        
        // AI view button
        document.getElementById('launchOpenHands')?.addEventListener('click', () => this.openOpenHands());
    }

    executeAction(action) {
        switch(action) {
            case 'terminal':
                this.openTerminal();
                break;
            case 'github':
                this.openGitHub();
                break;
            case 'openhands':
                this.openOpenHands();
                break;
            case 'vscode':
                this.openVSCode();
                break;
            case 'browser':
                this.openBrowser();
                break;
            case 'files':
                this.openFiles();
                break;
        }
    }

    // Command Palette
    setupCommandPalette() {
        const palette = document.getElementById('commandPalette');
        const paletteInput = document.getElementById('paletteInput');

        paletteInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                const selected = document.querySelector('.palette-result.selected');
                if (selected) {
                    selected.click();
                }
            }
        });
    }

    showCommandPalette(query) {
        const palette = document.getElementById('commandPalette');
        const results = document.getElementById('paletteResults');
        
        palette.classList.add('visible');
        
        const commands = this.getCommands();
        const filtered = commands.filter(cmd => 
            cmd.name.toLowerCase().includes(query) ||
            cmd.description.toLowerCase().includes(query)
        );

        results.innerHTML = filtered.map((cmd, i) => `
            <div class="palette-result ${i === 0 ? 'selected' : ''}" data-action="${cmd.action}">
                <span>${cmd.icon}</span>
                <div>
                    <div>${cmd.name}</div>
                    <small>${cmd.description}</small>
                </div>
            </div>
        `).join('');

        results.querySelectorAll('.palette-result').forEach(result => {
            result.addEventListener('click', () => {
                this.executeAction(result.dataset.action);
                this.hideCommandPalette();
            });
        });
    }

    hideCommandPalette() {
        const palette = document.getElementById('commandPalette');
        palette.classList.remove('visible');
    }

    getCommands() {
        return [
            { name: 'Terminal', description: 'Open Windows Terminal', icon: '⌥', action: 'terminal' },
            { name: 'GitHub', description: 'Open GitHub in browser', icon: '◐', action: 'github' },
            { name: 'OpenHands', description: 'Open OpenHands AI', icon: '◎', action: 'openhands' },
            { name: 'VS Code', description: 'Open Visual Studio Code', icon: '◇', action: 'vscode' },
            { name: 'Settings', description: 'Open Settings', icon: '◎', action: 'settings' },
            { name: 'New Terminal', description: 'Open new terminal tab', icon: '⌥', action: 'newTerminal' },
            { name: 'Search Files', description: 'Search in files', icon: '⌕', action: 'search' },
            { name: 'Projects', description: 'View all projects', icon: '◉', action: 'projects' },
        ];
    }

    // System Actions
    openTerminal() {
        // Windows Terminal
        this.openApp('cmd', '/c start wt');
    }

    openGitHub() {
        window.open('https://github.com', '_blank');
    }

    openOpenHands() {
        window.open('https://app.all-hands.dev', '_blank');
    }

    openVSCode() {
        this.openApp('code');
    }

    openBrowser() {
        this.openApp('cmd', '/c start chrome');
    }

    openFiles() {
        this.openApp('explorer');
    }

    openApp(app, args = '') {
        // This would work in Electron/NW.js environment
        // For browser, we show a notification
        console.log(`Opening: ${app}`);
        
        // Fallback for web
        if (typeof require === 'undefined') {
            this.showNotification(`Opening ${app}...`);
        }
    }

    // Projects
    loadProjects() {
        const stored = localStorage.getItem('linkup-projects');
        if (stored) {
            this.projects = JSON.parse(stored);
            this.renderProjects();
        }
    }

    saveProjects() {
        localStorage.setItem('linkup-projects', JSON.stringify(this.projects));
    }

    renderProjects() {
        const grid = document.getElementById('projectsGrid');
        const addCard = grid.querySelector('.add-new');
        
        // Clear existing projects (except add button)
        Array.from(grid.children).forEach(child => {
            if (!child.classList.contains('add-new')) {
                child.remove();
            }
        });

        this.projects.forEach(project => {
            const card = document.createElement('div');
            card.className = 'project-card';
            card.innerHTML = `
                <h4>${project.name}</h4>
                <p>${project.path}</p>
            `;
            card.addEventListener('click', () => this.openProject(project));
            grid.insertBefore(card, addCard);
        });

        // Setup add project button
        addCard.addEventListener('click', () => this.addProject());
    }

    addProject() {
        const name = prompt('Project name:');
        if (name) {
            const path = prompt('Project path:', 'D:\\Projects\\');
            if (path) {
                this.projects.push({ name, path });
                this.saveProjects();
                this.renderProjects();
            }
        }
    }

    openProject(project) {
        // Open in VS Code
        this.openApp('code', `"${project.path}"`);
    }

    // Git Info
    loadGitInfo() {
        const branchEl = document.getElementById('currentBranch');
        const addedEl = document.getElementById('added');
        const modifiedEl = document.getElementById('modified');
        
        // These would be populated by backend/extension
        if (branchEl) branchEl.textContent = 'main';
        if (addedEl) addedEl.textContent = '0';
        if (modifiedEl) modifiedEl.textContent = '0';
    }

    // System Status
    checkSystemStatus() {
        const statusItems = document.querySelectorAll('.status-item');
        
        // Check each tool
        const checks = [
            { name: 'Windows Terminal', check: () => true },
            { name: 'Git', check: () => true },
            { name: 'VS Code', check: () => true },
            { name: 'OpenHands', check: () => true },
        ];

        checks.forEach((tool, i) => {
            const item = statusItems[i];
            if (item) {
                const indicator = item.querySelector('.status-indicator');
                const isOnline = tool.check();
                indicator.classList.toggle('online', isOnline);
                indicator.classList.toggle('offline', !isOnline);
            }
        });
    }

    // Settings
    loadSettings() {
        const stored = localStorage.getItem('linkup-settings');
        return stored ? JSON.parse(stored) : {
            theme: 'dark',
            launchOnStartup: true,
            openLastProject: true,
            defaultShell: 'pwsh'
        };
    }

    saveSettings() {
        localStorage.setItem('linkup-settings', JSON.stringify(this.settings));
    }

    setupSettings() {
        const themeSelect = document.getElementById('themeSelect');
        const launchOnStartup = document.getElementById('launchOnStartup');
        const openLastProject = document.getElementById('openLastProject');
        const defaultShell = document.getElementById('defaultShell');

        if (themeSelect) {
            themeSelect.value = this.settings.theme;
            themeSelect.addEventListener('change', (e) => {
                this.settings.theme = e.target.value;
                this.saveSettings();
            });
        }

        if (launchOnStartup) {
            launchOnStartup.checked = this.settings.launchOnStartup;
            launchOnStartup.addEventListener('change', (e) => {
                this.settings.launchOnStartup = e.target.checked;
                this.saveSettings();
            });
        }

        if (openLastProject) {
            openLastProject.checked = this.settings.openLastProject;
            openLastProject.addEventListener('change', (e) => {
                this.settings.openLastProject = e.target.checked;
                this.saveSettings();
            });
        }

        if (defaultShell) {
            defaultShell.value = this.settings.defaultShell;
            defaultShell.addEventListener('change', (e) => {
                this.settings.defaultShell = e.target.value;
                this.saveSettings();
            });
        }
    }

    // Notifications
    showNotification(message) {
        // Simple notification
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 12px 24px;
            background: #1f6feb;
            color: white;
            border-radius: 6px;
            z-index: 1000;
        `;
        document.body.appendChild(notification);
        
        setTimeout(() => notification.remove(), 3000);
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.linkupLauncher = new LinkUpLauncher();
});
