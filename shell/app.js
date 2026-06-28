// LinkUp Studio Shell - Main Application

class LinkUpShell {
    constructor() {
        this.windows = {};
        this.activeWindow = 'dashboard';
        this.sidebarPanel = 'explorer';
        this.isMaximized = false;
        
        this.init();
    }

    init() {
        this.setupWindowControls();
        this.setupTabs();
        this.setupSidebar();
        this.setupMenu();
        this.setupQuickActions();
        this.setupControlCenter();
        this.setupDialogs();
        this.updateClock();
        setInterval(() => this.updateClock(), 1000);
    }

    // Window Controls
    setupWindowControls() {
        document.getElementById('minimizeBtn')?.addEventListener('click', () => this.minimize());
        document.getElementById('maximizeBtn')?.addEventListener('click', () => this.maximize());
        document.getElementById('closeBtn')?.addEventListener('click', () => this.close());
    }

    minimize() {
        // Would minimize window in Electron/Tauri
        console.log('Minimize window');
    }

    maximize() {
        this.isMaximized = !this.isMaximized;
        const btn = document.getElementById('maximizeBtn');
        if (btn) {
            btn.textContent = this.isMaximized ? '❐' : '□';
        }
        // Would maximize/restore in Electron/Tauri
        console.log(this.isMaximized ? 'Maximize' : 'Restore');
    }

    close() {
        // Would close window in Electron/Tauri
        console.log('Close window');
    }

    // Tabs
    setupTabs() {
        const tabs = document.querySelectorAll('.tab');
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                if (event.target.classList.contains('tab-close')) {
                    this.closeTab(tab.dataset.id);
                } else {
                    this.switchTab(tab.dataset.id);
                }
            });
        });

        document.getElementById('newTabBtn')?.addEventListener('click', () => this.newTab());
    }

    switchTab(windowId) {
        // Update tabs
        document.querySelectorAll('.tab').forEach(tab => {
            tab.classList.toggle('active', tab.dataset.id === windowId);
        });

        // Update windows
        document.querySelectorAll('.window').forEach(win => {
            win.classList.toggle('active', win.id === `${windowId}-window`);
        });

        this.activeWindow = windowId;
    }

    closeTab(windowId) {
        const tab = document.querySelector(`.tab[data-id="${windowId}"]`);
        if (tab) {
            tab.remove();
        }
        const win = document.getElementById(`${windowId}-window`);
        if (win) {
            win.remove();
        }
        
        // Switch to another tab
        const firstTab = document.querySelector('.tab');
        if (firstTab) {
            this.switchTab(firstTab.dataset.id);
        }
    }

    newTab() {
        const id = 'new' + Date.now();
        const tabsContainer = document.getElementById('tabs');
        
        const tab = document.createElement('div');
        tab.className = 'tab';
        tab.dataset.id = id;
        tab.innerHTML = `
            <span class="tab-icon">◉</span>
            <span class="tab-title">New Tab</span>
            <button class="tab-close">×</button>
        `;
        
        tabsContainer.appendChild(tab);
        
        // Add click handler
        tab.addEventListener('click', () => {
            if (event.target.classList.contains('tab-close')) {
                this.closeTab(id);
            } else {
                this.switchTab(id);
            }
        });

        // Add window
        const contentArea = document.getElementById('contentArea');
        const win = document.createElement('div');
        win.className = 'window';
        win.id = `${id}-window`;
        win.innerHTML = `
            <div class="window-content">
                <h2>New Tab</h2>
                <p>Content goes here...</p>
            </div>
        `;
        contentArea.appendChild(win);

        this.switchTab(id);
    }

    // Sidebar
    setupSidebar() {
        const sidebarTabs = document.querySelectorAll('.sidebar-tab');
        sidebarTabs.forEach(tab => {
            tab.addEventListener('click', () => {
                this.switchSidebarPanel(tab.dataset.panel);
            });
        });
    }

    switchSidebarPanel(panelId) {
        // Update tabs
        document.querySelectorAll('.sidebar-tab').forEach(tab => {
            tab.classList.toggle('active', tab.dataset.panel === panelId);
        });

        // Update panels
        document.querySelectorAll('.sidebar-panel').forEach(panel => {
            panel.classList.toggle('active', panel.id === `${panelId}-panel`);
        });

        this.sidebarPanel = panelId;
    }

    // Menu
    setupMenu() {
        const dropdownItems = document.querySelectorAll('.dropdown-item');
        dropdownItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const action = item.dataset.action;
                this.executeMenuAction(action);
            });
        });
    }

    executeMenuAction(action) {
        switch(action) {
            case 'newWindow':
                this.newWindow();
                break;
            case 'newTab':
                this.newTab();
                break;
            case 'openProject':
                this.openProject();
                break;
            case 'openFolder':
                this.openFolder();
                break;
            case 'save':
                this.save();
                break;
            case 'settings':
                this.showSettings();
                break;
            case 'exit':
                this.close();
                break;
            case 'toggleSidebar':
                this.toggleSidebar();
                break;
            case 'toggleTerminal':
                this.toggleTerminal();
                break;
            case 'toggleFullscreen':
                this.toggleFullscreen();
                break;
            case 'minimize':
                this.minimize();
                break;
            case 'maximize':
                this.maximize();
                break;
            case 'closeWindow':
                this.close();
                break;
            case 'about':
                this.showAbout();
                break;
            default:
                console.log('Action:', action);
        }
    }

    newWindow() {
        console.log('New window');
        // Would open new window in Electron/Tauri
    }

    openProject() {
        // Would open project dialog in Electron/Tauri
        const path = prompt('Enter project path:');
        if (path) {
            console.log('Open project:', path);
        }
    }

    openFolder() {
        // Would open folder dialog in Electron/Tauri
        const path = prompt('Enter folder path:');
        if (path) {
            console.log('Open folder:', path);
        }
    }

    save() {
        console.log('Save');
    }

    showSettings() {
        this.switchTab('settings');
    }

    toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        if (sidebar) {
            sidebar.style.display = sidebar.style.display === 'none' ? 'flex' : 'none';
        }
    }

    toggleTerminal() {
        const panel = document.getElementById('panel');
        if (panel) {
            panel.style.display = panel.style.display === 'none' ? 'flex' : 'none';
        }
    }

    toggleFullscreen() {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
        } else {
            document.exitFullscreen();
        }
    }

    // Quick Actions
    setupQuickActions() {
        const qaBtns = document.querySelectorAll('.qa-btn');
        qaBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const action = btn.dataset.action;
                this.executeQuickAction(action);
            });
        });

        // Projects
        document.getElementById('addProjectBtn')?.addEventListener('click', () => this.addProject());
        document.getElementById('addProjectCard')?.addEventListener('click', () => this.addProject());
    }

    executeQuickAction(action) {
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
        }
    }

    openTerminal() {
        this.switchTab('terminal');
    }

    openGitHub() {
        window.open('https://github.com', '_blank');
    }

    openOpenHands() {
        window.open('https://app.all-hands.dev', '_blank');
    }

    openVSCode() {
        console.log('Open VS Code');
    }

    // Projects
    addProject() {
        const name = prompt('Project name:');
        if (name) {
            const path = prompt('Project path:', 'D:\\Projects\\');
            if (path) {
                this.saveProject({ name, path });
                this.renderProjects();
            }
        }
    }

    saveProject(project) {
        const projects = JSON.parse(localStorage.getItem('linkup-shell-projects') || '[]');
        projects.push(project);
        localStorage.setItem('linkup-shell-projects', JSON.stringify(projects));
    }

    loadProjects() {
        return JSON.parse(localStorage.getItem('linkup-shell-projects') || '[]');
    }

    renderProjects() {
        const grid = document.getElementById('projectsGrid');
        const addCard = grid?.querySelector('.add-new');
        if (!addCard) return;

        // Clear existing
        Array.from(grid.children).forEach(child => {
            if (!child.classList.contains('add-new')) {
                child.remove();
            }
        });

        // Add project cards
        this.loadProjects().forEach(project => {
            const card = document.createElement('div');
            card.className = 'project-card';
            card.innerHTML = `
                <h4>${project.name}</h4>
                <p>${project.path}</p>
            `;
            card.addEventListener('click', () => this.openProjectPath(project.path));
            grid.insertBefore(card, addCard);
        });
    }

    openProjectPath(path) {
        console.log('Open project:', path);
        // Would open in VS Code or file explorer
    }

    // Control Center
    setupControlCenter() {
        const notificationBtn = document.getElementById('notificationCenter');
        notificationBtn?.addEventListener('click', () => this.toggleControlCenter());

        // Control buttons
        document.getElementById('wifiBtn')?.addEventListener('click', () => this.toggleControl('wifi'));
        document.getElementById('bluetoothBtn')?.addEventListener('click', () => this.toggleControl('bluetooth'));
        document.getElementById('airplaneBtn')?.addEventListener('click', () => this.toggleControl('airplane'));
        document.getElementById('nightLightBtn')?.addEventListener('click', () => this.toggleControl('night'));

        // Sliders
        document.getElementById('brightnessSlider')?.addEventListener('input', (e) => {
            console.log('Brightness:', e.target.value);
        });

        document.getElementById('volumeSlider')?.addEventListener('input', (e) => {
            console.log('Volume:', e.target.value);
        });

        // Quick actions
        document.getElementById('openHandsBtn')?.addEventListener('click', () => {
            this.openOpenHands();
            this.toggleControlCenter();
        });

        document.getElementById('settingsBtn')?.addEventListener('click', () => {
            this.toggleControlCenter();
        });

        // Close on click outside
        document.addEventListener('click', (e) => {
            const cc = document.getElementById('controlCenter');
            const btn = document.getElementById('notificationCenter');
            if (cc && btn && !cc.contains(e.target) && !btn.contains(e.target)) {
                cc.classList.remove('visible');
            }
        });
    }

    toggleControlCenter() {
        const cc = document.getElementById('controlCenter');
        if (cc) {
            cc.classList.toggle('visible');
        }
    }

    toggleControl(type) {
        const btn = document.getElementById(`${type}Btn`);
        if (btn) {
            btn.classList.toggle('active');
        }
        console.log('Toggle:', type);
    }

    // Dialogs
    setupDialogs() {
        document.getElementById('closeAboutBtn')?.addEventListener('click', () => this.hideAbout());
        
        // Close on backdrop click
        document.getElementById('aboutDialog')?.addEventListener('click', (e) => {
            if (e.target.id === 'aboutDialog') {
                this.hideAbout();
            }
        });
    }

    showAbout() {
        document.getElementById('aboutDialog')?.classList.add('visible');
    }

    hideAbout() {
        document.getElementById('aboutDialog')?.classList.remove('visible');
    }

    // Clock
    updateClock() {
        const clock = document.getElementById('clock');
        if (clock) {
            const now = new Date();
            clock.textContent = now.toLocaleTimeString('uk-UA', { 
                hour: '2-digit', 
                minute: '2-digit' 
            });
        }
    }

    // Settings
    showSettings() {
        // Would show settings view
        console.log('Show settings');
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.linkupShell = new LinkUpShell();
});
