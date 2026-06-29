// LinkUp Studio Theme Engine - Main Application

class ThemeEngine {
    constructor() {
        this.currentTheme = 'github-dark';
        this.currentIconPack = 'linkup';
        this.currentWallpaper = 'linkup-dark';
        this.currentFont = 'jetbrains-mono';
        this.accentColor = '#58a6ff';
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupThemeActions();
        this.setupIconActions();
        this.setupWallpaperActions();
        this.setupFontActions();
        this.setupColorActions();
        this.setupExportImport();
        this.loadSettings();
    }

    loadSettings() {
        const stored = localStorage.getItem('linkup-theme-settings');
        if (stored) {
            const settings = JSON.parse(stored);
            this.currentTheme = settings.theme || this.currentTheme;
            this.currentIconPack = settings.iconPack || this.currentIconPack;
            this.currentWallpaper = settings.wallpaper || this.currentWallpaper;
            this.currentFont = settings.font || this.currentFont;
            this.accentColor = settings.accentColor || this.accentColor;
        }
    }

    saveSettings() {
        localStorage.setItem('linkup-theme-settings', JSON.stringify({
            theme: this.currentTheme,
            iconPack: this.currentIconPack,
            wallpaper: this.currentWallpaper,
            font: this.currentFont,
            accentColor: this.accentColor
        }));
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.te-nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const view = item.dataset.view;
                this.switchView(view);
            });
        });
    }

    switchView(viewName) {
        document.querySelectorAll('.te-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });
        document.querySelectorAll('.te-view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });
    }

    // Theme Actions
    setupThemeActions() {
        // Theme cards
        document.querySelectorAll('.theme-card:not(.add-new)').forEach(card => {
            const applyBtn = card.querySelector('.theme-actions .btn-primary, .theme-actions .btn-secondary');
            const editBtn = card.querySelector('.theme-actions .btn-icon');
            
            applyBtn?.addEventListener('click', () => {
                const themeName = card.querySelector('.theme-info h3').textContent.toLowerCase().replace(' ', '-');
                this.applyTheme(themeName);
                
                // Update UI
                document.querySelectorAll('.theme-card').forEach(c => c.classList.remove('active'));
                card.classList.add('active');
                applyBtn.textContent = 'Applied';
            });

            editBtn?.addEventListener('click', () => {
                this.editTheme(card);
            });
        });

        // Add new theme
        document.getElementById('addThemeCard')?.addEventListener('click', () => {
            this.createNewTheme();
        });

        // Create theme button
        document.getElementById('newThemeBtn')?.addEventListener('click', () => {
            this.createNewTheme();
        });
    }

    applyTheme(themeName) {
        console.log('Applying theme:', themeName);
        this.currentTheme = themeName;
        this.saveSettings();
        
        // Would apply CSS variables
        document.body.className = `theme-${themeName}`;
    }

    editTheme(card) {
        const themeName = card.querySelector('.theme-info h3').textContent;
        console.log('Editing theme:', themeName);
        alert(`Theme editor for "${themeName}" - Coming soon!`);
    }

    createNewTheme() {
        const name = prompt('Theme name:');
        if (name) {
            console.log('Creating theme:', name);
            alert('Theme creator - Coming soon!');
        }
    }

    // Icon Actions
    setupIconActions() {
        document.querySelectorAll('.icon-pack-card').forEach(card => {
            const applyBtn = card.querySelector('button');
            applyBtn?.addEventListener('click', () => {
                const packName = card.querySelector('h3').textContent.toLowerCase();
                this.applyIconPack(packName);
                
                // Update UI
                document.querySelectorAll('.icon-pack-card').forEach(c => {
                    c.querySelector('button').textContent = 'Apply';
                    c.querySelector('button').className = 'btn-secondary';
                });
                applyBtn.textContent = 'Applied';
                applyBtn.className = 'btn-primary';
            });
        });
    }

    applyIconPack(packName) {
        console.log('Applying icon pack:', packName);
        this.currentIconPack = packName;
        this.saveSettings();
    }

    // Wallpaper Actions
    setupWallpaperActions() {
        document.querySelectorAll('.wallpaper-card').forEach(card => {
            const applyBtn = card.querySelector('.wallpaper-actions button');
            applyBtn?.addEventListener('click', () => {
                const wallpaperName = card.querySelector('.wallpaper-info h3').textContent.toLowerCase().replace(' ', '-');
                this.applyWallpaper(wallpaperName);
                
                // Update UI
                document.querySelectorAll('.wallpaper-card').forEach(c => c.classList.remove('active'));
                card.classList.add('active');
            });
        });
    }

    applyWallpaper(wallpaperName) {
        console.log('Applying wallpaper:', wallpaperName);
        this.currentWallpaper = wallpaperName;
        this.saveSettings();
    }

    // Font Actions
    setupFontActions() {
        document.querySelectorAll('.font-card').forEach(card => {
            const applyBtn = card.querySelector('.font-actions button');
            applyBtn?.addEventListener('click', () => {
                const fontName = card.querySelector('.font-info h3').textContent.toLowerCase().replace(' ', '-');
                this.applyFont(fontName);
                
                // Update UI
                document.querySelectorAll('.font-card').forEach(c => {
                    c.classList.remove('active');
                    c.querySelector('button').textContent = 'Apply';
                    c.querySelector('button').className = 'btn-secondary';
                });
                card.classList.add('active');
                applyBtn.textContent = 'Applied';
                applyBtn.className = 'btn-primary';
            });
        });
    }

    applyFont(fontName) {
        console.log('Applying font:', fontName);
        this.currentFont = fontName;
        this.saveSettings();
        
        // Would update font-family
        const fontFamily = fontName.replace('-', ' ');
        document.body.style.fontFamily = `'${fontFamily}', sans-serif`;
    }

    // Color Actions
    setupColorActions() {
        // Accent color swatches
        document.querySelectorAll('.color-swatch').forEach(swatch => {
            swatch.addEventListener('click', () => {
                const color = swatch.dataset.color;
                this.applyAccentColor(color);
                
                // Update UI
                document.querySelectorAll('.color-swatch').forEach(s => s.classList.remove('active'));
                swatch.classList.add('active');
            });
        });

        // Custom color input
        const customInput = document.getElementById('customColorInput');
        const customHex = document.getElementById('customColorHex');
        
        customInput?.addEventListener('input', (e) => {
            customHex.value = e.target.value;
        });

        customHex?.addEventListener('input', (e) => {
            if (/^#[0-9A-Fa-f]{6}$/.test(e.target.value)) {
                customInput.value = e.target.value;
            }
        });

        // Add custom color
        document.getElementById('addColorBtn')?.addEventListener('click', () => {
            const color = customHex.value;
            this.addCustomColor(color);
        });

        // Generate palette
        document.getElementById('generatePaletteBtn')?.addEventListener('click', () => {
            this.generateRandomPalette();
        });

        // Save palette
        document.getElementById('savePaletteBtn')?.addEventListener('click', () => {
            this.savePalette();
        });
    }

    applyAccentColor(color) {
        console.log('Applying accent color:', color);
        this.accentColor = color;
        this.saveSettings();
        
        // Update CSS variable
        document.documentElement.style.setProperty('--accent-fg', color);
        document.documentElement.style.setProperty('--accent-emphasis', this.adjustColorBrightness(color, -20));
    }

    addCustomColor(color) {
        const list = document.getElementById('customColorsList');
        if (list) {
            const item = document.createElement('div');
            item.className = 'custom-color-item';
            item.style.background = color;
            item.addEventListener('click', () => {
                this.applyAccentColor(color);
            });
            list.appendChild(item);
        }
    }

    generateRandomPalette() {
        const colors = [];
        for (let i = 0; i < 5; i++) {
            colors.push('#' + Math.floor(Math.random()*16777215).toString(16).padStart(6, '0'));
        }
        
        const preview = document.getElementById('palettePreview');
        if (preview) {
            preview.innerHTML = colors.map(color => 
                `<div class="palette-color" style="background: ${color};"><span>${color}</span></div>`
            ).join('');
        }
    }

    savePalette() {
        const colors = [];
        document.querySelectorAll('.palette-color').forEach(el => {
            colors.push(el.style.backgroundColor);
        });
        console.log('Saving palette:', colors);
        alert('Palette saved!');
    }

    adjustColorBrightness(hex, percent) {
        const num = parseInt(hex.replace('#', ''), 16);
        const amt = Math.round(2.55 * percent);
        const R = (num >> 16) + amt;
        const G = (num >> 8 & 0x00FF) + amt;
        const B = (num & 0x0000FF) + amt;
        return '#' + (0x1000000 + 
            (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 + 
            (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 + 
            (B < 255 ? B < 1 ? 0 : B : 255)
        ).toString(16).slice(1);
    }

    // Export/Import
    setupExportImport() {
        document.getElementById('exportBtn')?.addEventListener('click', () => {
            this.exportTheme();
        });

        document.getElementById('importBtn')?.addEventListener('click', () => {
            document.getElementById('importFile')?.click();
        });

        document.getElementById('importFile')?.addEventListener('change', (e) => {
            this.importTheme(e.target.files[0]);
        });

        // Dropzone
        const dropzone = document.getElementById('importDropzone');
        dropzone?.addEventListener('click', () => {
            document.getElementById('importFile')?.click();
        });

        dropzone?.addEventListener('dragover', (e) => {
            e.preventDefault();
            dropzone.style.borderColor = 'var(--accent-fg)';
        });

        dropzone?.addEventListener('dragleave', () => {
            dropzone.style.borderColor = 'var(--border-default)';
        });

        dropzone?.addEventListener('drop', (e) => {
            e.preventDefault();
            dropzone.style.borderColor = 'var(--border-default)';
            const file = e.dataTransfer?.files[0];
            if (file) {
                this.importTheme(file);
            }
        });
    }

    exportTheme() {
        const settings = {
            theme: this.currentTheme,
            iconPack: this.currentIconPack,
            wallpaper: this.currentWallpaper,
            font: this.currentFont,
            accentColor: this.accentColor,
            exportedAt: new Date().toISOString()
        };

        const blob = new Blob([JSON.stringify(settings, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `linkup-theme-${Date.now()}.json`;
        a.click();
        URL.revokeObjectURL(url);
        
        console.log('Theme exported');
        alert('Theme exported successfully!');
    }

    importTheme(file) {
        if (!file) return;
        
        const reader = new FileReader();
        reader.onload = (e) => {
            try {
                const settings = JSON.parse(e.target.result);
                this.currentTheme = settings.theme;
                this.currentIconPack = settings.iconPack;
                this.currentWallpaper = settings.wallpaper;
                this.currentFont = settings.font;
                this.accentColor = settings.accentColor;
                
                this.saveSettings();
                alert('Theme imported successfully!');
            } catch (err) {
                alert('Failed to import theme: Invalid file format');
            }
        };
        reader.readAsText(file);
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.themeEngine = new ThemeEngine();
});