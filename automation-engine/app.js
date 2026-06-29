// LinkUp Studio Automation Engine - Main Application

class AutomationEngine {
    constructor() {
        this.scripts = this.loadScripts();
        this.hotkeys = this.loadHotkeys();
        this.macros = this.loadMacros();
        this.schedules = this.loadSchedules();
        this.logs = [];
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupActions();
        this.setupQuickActions();
        this.setupScheduler();
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.ae-nav-item');
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
        document.querySelectorAll('.ae-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });

        // Update views
        document.querySelectorAll('.ae-view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });
    }

    // Scripts
    loadScripts() {
        const stored = localStorage.getItem('linkup-scripts');
        return stored ? JSON.parse(stored) : [];
    }

    saveScripts() {
        localStorage.setItem('linkup-scripts', JSON.stringify(this.scripts));
    }

    // Hotkeys
    loadHotkeys() {
        const stored = localStorage.getItem('linkup-hotkeys');
        return stored ? JSON.parse(stored) : [
            { keys: 'Ctrl+Shift+G', action: 'Git Sync', description: 'Sync all repositories', active: true },
            { keys: 'Ctrl+Shift+B', action: 'Build Project', description: 'Run build command', active: true },
            { keys: 'Ctrl+Shift+T', action: 'Run Tests', description: 'Execute test suite', active: true },
            { keys: 'Ctrl+Shift+D', action: 'Deploy', description: 'Deploy to production', active: false },
        ];
    }

    saveHotkeys() {
        localStorage.setItem('linkup-hotkeys', JSON.stringify(this.hotkeys));
    }

    // Macros
    loadMacros() {
        const stored = localStorage.getItem('linkup-macros');
        return stored ? JSON.parse(stored) : [
            {
                name: 'Morning Startup',
                active: true,
                steps: [
                    'Open Terminal',
                    'Navigate to projects',
                    'Git pull all',
                    'Open VS Code'
                ]
            },
            {
                name: 'Git Commit & Push',
                active: true,
                steps: [
                    'Git add .',
                    'Git commit',
                    'Git push'
                ]
            }
        ];
    }

    saveMacros() {
        localStorage.setItem('linkup-macros', JSON.stringify(this.macros));
    }

    // Schedules
    loadSchedules() {
        const stored = localStorage.getItem('linkup-schedules');
        return stored ? JSON.parse(stored) : [
            { time: '09:00', repeat: 'Daily', name: 'Morning Git Sync', active: true },
            { time: '18:00', repeat: 'Weekdays', name: 'Evening Backup', active: true },
            { time: '15m', repeat: 'Interval', name: 'Health Check', active: true },
            { time: 'Sunday', repeat: 'Weekly', name: 'Weekly Cleanup', active: false },
        ];
    }

    saveSchedules() {
        localStorage.setItem('linkup-schedules', JSON.stringify(this.schedules));
    }

    // Actions
    setupActions() {
        // New automation
        document.getElementById('newAutomationBtn')?.addEventListener('click', () => {
            this.createNewAutomation();
        });

        // New script
        document.getElementById('newScriptBtn')?.addEventListener('click', () => {
            this.createNewScript();
        });

        // New hotkey
        document.getElementById('newHotkeyBtn')?.addEventListener('click', () => {
            this.createNewHotkey();
        });

        // New macro
        document.getElementById('newMacroBtn')?.addEventListener('click', () => {
            this.createNewMacro();
        });

        // New schedule
        document.getElementById('newScheduleBtn')?.addEventListener('click', () => {
            this.createNewSchedule();
        });

        // Run buttons
        document.querySelectorAll('[title="Run"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.runAutomation(btn);
            });
        });

        // Delete buttons
        document.querySelectorAll('[title="Delete"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.deleteAutomation(btn);
            });
        });
    }

    // Quick Actions
    setupQuickActions() {
        document.querySelectorAll('.quick-action-card').forEach(card => {
            card.addEventListener('click', () => {
                const action = card.dataset.action;
                this.executeQuickAction(action);
            });
        });
    }

    executeQuickAction(action) {
        console.log('Executing quick action:', action);
        
        // Log the action
        this.addLog({
            type: 'quick-action',
            name: action,
            status: 'success',
            message: `${action} completed successfully`,
            duration: Math.random() * 10 + 1
        });

        // Simulate execution
        alert(`${action} executed!`);
    }

    // Scheduler
    setupScheduler() {
        // Start scheduler loop
        setInterval(() => {
            this.checkSchedules();
        }, 60000); // Check every minute
    }

    checkSchedules() {
        const now = new Date();
        const currentTime = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
        
        this.schedules.forEach(schedule => {
            if (schedule.active && schedule.time === currentTime) {
                console.log('Running scheduled task:', schedule.name);
                this.addLog({
                    type: 'schedule',
                    name: schedule.name,
                    status: 'success',
                    message: 'Scheduled task completed',
                    duration: Math.random() * 10 + 1
                });
            }
        });
    }

    // Create new items
    createNewAutomation() {
        const type = prompt('Automation type (script, hotkey, macro, schedule):', 'script');
        switch(type) {
            case 'script': this.createNewScript(); break;
            case 'hotkey': this.createNewHotkey(); break;
            case 'macro': this.createNewMacro(); break;
            case 'schedule': this.createNewSchedule(); break;
        }
    }

    createNewScript() {
        const name = prompt('Script name:');
        if (name) {
            const code = prompt('Script code:');
            this.scripts.push({ name, code, active: true });
            this.saveScripts();
            console.log('Script created:', name);
        }
    }

    createNewHotkey() {
        const keys = prompt('Hotkey (e.g., Ctrl+Shift+K):');
        if (keys) {
            const action = prompt('Action name:');
            const description = prompt('Description:');
            this.hotkeys.push({ keys, action, description, active: true });
            this.saveHotkeys();
            console.log('Hotkey created:', keys);
        }
    }

    createNewMacro() {
        const name = prompt('Macro name:');
        if (name) {
            this.macros.push({ name, active: true, steps: [] });
            this.saveMacros();
            console.log('Macro created:', name);
        }
    }

    createNewSchedule() {
        const name = prompt('Schedule name:');
        if (name) {
            const time = prompt('Time (e.g., 09:00):');
            const repeat = prompt('Repeat (Daily, Weekly, etc.):', 'Daily');
            this.schedules.push({ time, repeat, name, active: true });
            this.saveSchedules();
            console.log('Schedule created:', name);
        }
    }

    // Run automation
    runAutomation(btn) {
        const card = btn.closest('.script-card, .macro-card');
        const name = card?.querySelector('h3')?.textContent || 'Unknown';
        
        console.log('Running:', name);
        
        this.addLog({
            type: 'script',
            name: name,
            status: 'success',
            message: 'Automation completed',
            duration: Math.random() * 10 + 1
        });

        alert(`Running: ${name}`);
    }

    // Delete automation
    deleteAutomation(btn) {
        if (confirm('Are you sure you want to delete this automation?')) {
            const card = btn.closest('.script-card, .macro-card, .hotkey-item, .schedule-item');
            card?.remove();
        }
    }

    // Logs
    addLog(entry) {
        entry.time = new Date().toLocaleTimeString();
        this.logs.unshift(entry);
        this.logs = this.logs.slice(0, 100); // Keep last 100
        this.renderLogs();
    }

    renderLogs() {
        // Would render logs list
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.automationEngine = new AutomationEngine();
});