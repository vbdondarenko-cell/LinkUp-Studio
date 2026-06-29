// LinkUp Studio Workspace Restore - Main Application

class WorkspaceRestore {
    constructor() {
        this.sessions = this.loadSessions();
        this.autoSaveEnabled = true;
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupModals();
        this.setupActions();
        this.startAutoSave();
    }

    loadSessions() {
        const stored = localStorage.getItem('linkup-sessions');
        return stored ? JSON.parse(stored) : [];
    }

    saveSessions() {
        localStorage.setItem('linkup-sessions', JSON.stringify(this.sessions));
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.wsr-nav-item');
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
        document.querySelectorAll('.wsr-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });

        // Update views
        document.querySelectorAll('.wsr-view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });
    }

    // Modals
    setupModals() {
        const modal = document.getElementById('restoreModal');
        
        document.getElementById('closeRestoreBtn')?.addEventListener('click', () => {
            modal.classList.remove('visible');
        });

        document.getElementById('cancelRestoreBtn')?.addEventListener('click', () => {
            modal.classList.remove('visible');
        });

        document.getElementById('confirmRestoreBtn')?.addEventListener('click', () => {
            this.confirmRestore();
        });

        modal?.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('visible');
            }
        });
    }

    // Actions
    setupActions() {
        // Auto-save toggle
        document.getElementById('autoSaveBtn')?.addEventListener('click', () => {
            this.toggleAutoSave();
        });

        // Save current session
        document.getElementById('saveSessionBtn')?.addEventListener('click', () => {
            this.saveCurrentSession();
        });

        // Restore buttons
        document.querySelectorAll('.restore-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const sessionId = btn.dataset.session;
                this.showRestoreModal(sessionId);
            });
        });

        // Favorite buttons
        document.querySelectorAll('.favorite-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                btn.classList.toggle('active');
            });
        });

        // Clear all
        document.getElementById('clearAllBtn')?.addEventListener('click', () => {
            this.clearAllSessions();
        });

        // Restore current
        document.getElementById('restoreCurrentBtn')?.addEventListener('click', () => {
            this.saveCurrentSession();
        });
    }

    toggleAutoSave() {
        this.autoSaveEnabled = !this.autoSaveEnabled;
        const indicator = document.querySelector('.auto-save-indicator');
        if (indicator) {
            indicator.classList.toggle('active', this.autoSaveEnabled);
        }
        
        if (this.autoSaveEnabled) {
            console.log('Auto-save enabled');
            this.startAutoSave();
        } else {
            console.log('Auto-save disabled');
        }
    }

    startAutoSave() {
        if (!this.autoSaveEnabled) return;

        // Auto-save every 15 minutes
        setInterval(() => {
            if (this.autoSaveEnabled) {
                this.autoSave();
            }
        }, 15 * 60 * 1000); // 15 minutes
    }

    autoSave() {
        const currentSession = {
            id: Date.now(),
            name: 'Auto-save ' + new Date().toLocaleString(),
            timestamp: new Date().toISOString(),
            components: {
                projects: 4,
                terminals: 3,
                browser: 2,
                openhands: 1
            }
        };

        // Keep only last 10 auto-saves
        this.sessions = this.sessions.filter(s => !s.name.startsWith('Auto-save'));
        this.sessions.unshift(currentSession);

        console.log('Auto-saved session:', currentSession.name);
        this.saveSessions();
    }

    saveCurrentSession() {
        const name = prompt('Session name:', 'My Session');
        if (name) {
            const session = {
                id: Date.now(),
                name: name,
                timestamp: new Date().toISOString(),
                components: {
                    projects: 4,
                    terminals: 3,
                    browser: 2,
                    openhands: 1
                }
            };

            this.sessions.unshift(session);
            this.saveSessions();
            
            console.log('Session saved:', name);
            alert('Session saved successfully!');
        }
    }

    showRestoreModal(sessionId) {
        this.selectedSession = sessionId;
        const modal = document.getElementById('restoreModal');
        if (modal) {
            modal.classList.add('visible');
        }
    }

    confirmRestore() {
        console.log('Restoring session:', this.selectedSession);
        
        // Would restore the session here
        // - Close current applications
        // - Open saved projects
        // - Restore terminal tabs
        // - Restore browser tabs
        // - Restore OpenHands

        alert('Session restored! (Demo mode)');
        
        const modal = document.getElementById('restoreModal');
        if (modal) {
            modal.classList.remove('visible');
        }
    }

    clearAllSessions() {
        if (confirm('Are you sure you want to delete all saved sessions?')) {
            this.sessions = [];
            this.saveSessions();
            console.log('All sessions cleared');
            alert('All sessions deleted!');
        }
    }

    // Session management
    getCurrentSession() {
        return {
            projects: this.getOpenProjects(),
            terminals: this.getOpenTerminals(),
            browser: this.getOpenBrowserTabs(),
            openhands: this.getOpenHandsSessions()
        };
    }

    getOpenProjects() {
        // Would get from system
        return ['LinkUp-Studio', 'MyProject'];
    }

    getOpenTerminals() {
        // Would get from Windows Terminal
        return ['PowerShell', 'bash'];
    }

    getOpenBrowserTabs() {
        // Would get from browser
        return ['GitHub', 'OpenHands'];
    }

    getOpenHandsSessions() {
        // Would get from OpenHands
        return ['Main Chat'];
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.workspaceRestore = new WorkspaceRestore();
});
