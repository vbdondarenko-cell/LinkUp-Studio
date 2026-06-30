// LinkUp Studio Settings - Main Application

class SettingsApp {
    constructor() {
        this.settings = this.loadSettings();
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupToggles();
        this.setupSelects();
        this.setupSliders();
        this.setupButtons();
        this.setupAccentColors();
        this.setupPerformanceStats();
        this.applySettings();
    }

    loadSettings() {
        const stored = localStorage.getItem('linkup-settings');
        return stored ? JSON.parse(stored) : this.getDefaults();
    }

    getDefaults() {
        return {
            startup: {
                launchOnStartup: true,
                restoreSession: true,
                showSplash: true
            },
            updates: {
                autoCheck: true,
                channel: 'stable'
            },
            language: 'en',
            dateFormat: 'dmy',
            appearance: {
                theme: 'github-dark',
                iconTheme: 'linkup',
                accentColor: '#58a6ff',
                fontFamily: 'jetbrains',
                fontSize: 14,
                sidebarPosition: 'left',
                tabBarPosition: 'top'
            },
            ai: {
                model: 'claude',
                temperature: 70,
                maxTokens: 4096,
                autoSaveConversations: true,
                suggestions: true,
                codeCompletion: true
            },
            workspace: {
                projectsFolder: 'D:\\Projects',
                recentLimit: 20,
                defaultShell: 'pwsh',
                shellTheme: 'github-dark',
                terminalFontSize: 14,
                showHiddenFiles: false,
                confirmDelete: true
            },
            performance: {
                hardwareAcceleration: true,
                reducedMotion: false,
                autoSaveInterval: 15,
                caching: true,
                indexing: true
            }
        };
    }

    saveSettings() {
        localStorage.setItem('linkup-settings', JSON.stringify(this.settings));
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.settings-nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const section = item.dataset.section;
                this.switchSection(section);
            });
        });
    }

    switchSection(sectionName) {
        // Update nav
        document.querySelectorAll('.settings-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.section === sectionName);
        });

        // Update sections
        document.querySelectorAll('.settings-section').forEach(section => {
            section.classList.toggle('active', section.id === `${sectionName}-section`);
        });
    }

    // Toggles
    setupToggles() {
        document.querySelectorAll('.setting-toggle').forEach(toggle => {
            toggle.addEventListener('change', (e) => {
                console.log('Toggle changed:', e.target.checked);
                this.saveSettings();
            });
        });
    }

    // Selects
    setupSelects() {
        document.querySelectorAll('.setting-select').forEach(select => {
            select.addEventListener('change', (e) => {
                console.log('Setting changed:', e.target.value);
                this.saveSettings();
            });
        });
    }

    // Sliders
    setupSliders() {
        document.querySelectorAll('.setting-slider').forEach(slider => {
            slider.addEventListener('input', (e) => {
                const valueSpan = slider.parentElement.querySelector('.font-size-value');
                if (valueSpan) {
                    valueSpan.textContent = e.target.value + (e.target.max <= 100 ? '.' + Math.round(e.target.value * 0.1) : 'px');
                }
            });

            slider.addEventListener('change', () => {
                this.saveSettings();
            });
        });
    }

    // Buttons
    setupButtons() {
        // Show API key
        document.getElementById('showApiKeyBtn')?.addEventListener('click', () => {
            const input = document.getElementById('apiKeyInput');
            if (input) {
                input.type = input.type === 'password' ? 'text' : 'password';
            }
        });

        // Reset shortcuts
        document.getElementById('resetShortcutsBtn')?.addEventListener('click', () => {
            if (confirm('Reset all keyboard shortcuts to defaults?')) {
                alert('Shortcuts reset!');
            }
        });

        // Export shortcuts
        document.getElementById('exportShortcutsBtn')?.addEventListener('click', () => {
            alert('Export shortcuts - Coming soon!');
        });

        // Import shortcuts
        document.getElementById('importShortcutsBtn')?.addEventListener('click', () => {
            alert('Import shortcuts - Coming soon!');
        });

        // Check for updates
        document.getElementById('checkUpdatesBtn')?.addEventListener('click', () => {
            alert('Checking for updates...');
            setTimeout(() => {
                alert('You are running the latest version!');
            }, 1000);
        });

        // Open logs
        document.getElementById('openLogsBtn')?.addEventListener('click', () => {
            alert('Opening logs folder...');
        });

        // Clear cache
        document.querySelectorAll('.btn-secondary').forEach(btn => {
            if (btn.textContent === 'Clear Cache') {
                btn.addEventListener('click', () => {
                    if (confirm('Clear all cache?')) {
                        alert('Cache cleared!');
                    }
                });
            }
        });
    }

    // Accent Colors
    setupAccentColors() {
        document.querySelectorAll('.accent-color').forEach(btn => {
            btn.addEventListener('click', () => {
                const color = btn.dataset.color;
                
                // Update UI
                document.querySelectorAll('.accent-color').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                
                // Update settings
                this.settings.appearance.accentColor = color;
                this.saveSettings();
                
                // Apply color
                this.applyAccentColor(color);
            });
        });
    }

    applyAccentColor(color) {
        document.documentElement.style.setProperty('--accent-fg', color);
        document.documentElement.style.setProperty('--accent-emphasis', this.adjustColorBrightness(color, -20));
    }

    adjustColorBrightness(hex, percent) {
        const num = parseInt(hex.replace('#', ''), 16);
        const amt = Math.round(2.55 * percent);
        const R = Math.min(255, Math.max(0, (num >> 16) + amt));
        const G = Math.min(255, Math.max(0, ((num >> 8) & 0x00FF) + amt));
        const B = Math.min(255, Math.max(0, (num & 0x0000FF) + amt));
        return '#' + (0x1000000 + (R * 0x10000) + (G * 0x100) + B).toString(16).slice(1);
    }

    // Performance Stats
    setupPerformanceStats() {
        // Simulated stats update
        this.updatePerformanceStats();
        setInterval(() => this.updatePerformanceStats(), 5000);
    }

    updatePerformanceStats() {
        const memory = Math.floor(Math.random() * 200 + 300);
        const cpu = Math.floor(Math.random() * 30 + 5);
        
        const memoryBar = document.querySelector('.stat-item:nth-child(1) .stat-fill');
        const memoryValue = document.querySelector('.stat-item:nth-child(1) .stat-value');
        const cpuBar = document.querySelector('.stat-item:nth-child(2) .stat-fill');
        const cpuValue = document.querySelector('.stat-item:nth-child(2) .stat-value');
        
        if (memoryBar) memoryBar.style.width = (memory / 1024 * 100) + '%';
        if (memoryValue) memoryValue.textContent = memory + ' MB';
        if (cpuBar) cpuBar.style.width = cpu + '%';
        if (cpuValue) cpuValue.textContent = cpu + '%';
    }

    // Apply Settings
    applySettings() {
        // Apply accent color
        this.applyAccentColor(this.settings.appearance.accentColor);
        
        // Apply theme
        console.log('Applied settings:', this.settings);
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.settingsApp = new SettingsApp();
});