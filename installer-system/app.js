// LinkUp Studio Installer System - Main Application

class InstallerSystem {
    constructor() {
        this.version = '1.0.0';
        this.build = '2024.01.15';
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupInstallActions();
        this.setupUpdateActions();
        this.setupBackupActions();
        this.setupRestoreActions();
        this.setupUninstallActions();
        this.setupModals();
        this.setupToggles();
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.installer-nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const section = item.dataset.section;
                this.switchSection(section);
            });
        });
    }

    switchSection(sectionName) {
        document.querySelectorAll('.installer-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.section === sectionName);
        });
        document.querySelectorAll('.installer-section').forEach(section => {
            section.classList.toggle('active', section.id === `${sectionName}-section`);
        });
    }

    // Install Actions
    setupInstallActions() {
        document.getElementById('repairInstallBtn')?.addEventListener('click', () => {
            this.showProgress('Repairing Installation...', () => {
                alert('Installation repaired successfully!');
            });
        });

        document.getElementById('modifyInstallBtn')?.addEventListener('click', () => {
            alert('Modify installation - Coming soon!');
        });
    }

    // Update Actions
    setupUpdateActions() {
        document.getElementById('checkUpdatesBtn')?.addEventListener('click', () => {
            this.showProgress('Checking for Updates...', () => {
                alert('You are running the latest version!');
            });
        });

        document.getElementById('viewChangelogBtn')?.addEventListener('click', () => {
            alert('Changelog:\n\nv1.0.0\n- Initial release\n- GitHub Dark theme\n- AI Workspace\n- Developer Tools');
        });
    }

    // Backup Actions
    setupBackupActions() {
        document.getElementById('createBackupBtn')?.addEventListener('click', () => {
            this.showProgress('Creating Backup...', () => {
                alert('Backup created successfully!');
            });
        });

        // Backup item actions
        document.querySelectorAll('.backup-item .btn-secondary').forEach(btn => {
            btn.addEventListener('click', () => {
                if (confirm('Restore this backup?')) {
                    this.showProgress('Restoring Backup...', () => {
                        alert('Backup restored successfully!');
                    });
                }
            });
        });

        document.querySelectorAll('.backup-item .btn-icon').forEach(btn => {
            btn.addEventListener('click', () => {
                if (confirm('Delete this backup?')) {
                    btn.closest('.backup-item').remove();
                }
            });
        });
    }

    // Restore Actions
    setupRestoreActions() {
        const dropzone = document.getElementById('restoreDropzone');
        
        dropzone?.addEventListener('click', () => {
            document.getElementById('restoreFile')?.click();
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
                this.showProgress('Restoring Backup...', () => {
                    alert('Backup restored successfully!');
                });
            }
        });

        document.getElementById('restoreFile')?.addEventListener('change', (e) => {
            const file = e.target.files[0];
            if (file) {
                this.showProgress('Restoring Backup...', () => {
                    alert('Backup restored successfully!');
                });
            }
        });
    }

    // Uninstall Actions
    setupUninstallActions() {
        document.getElementById('uninstallBtn')?.addEventListener('click', () => {
            this.showConfirm('Are you sure you want to uninstall LinkUp Studio?', () => {
                this.showProgress('Uninstalling...', () => {
                    alert('LinkUp Studio has been uninstalled.');
                });
            });
        });
    }

    // Modals
    setupModals() {
        document.getElementById('closeConfirmBtn')?.addEventListener('click', () => {
            this.hideConfirm();
        });

        document.getElementById('cancelConfirmBtn')?.addEventListener('click', () => {
            this.hideConfirm();
        });

        document.getElementById('confirmModal')?.addEventListener('click', (e) => {
            if (e.target.id === 'confirmModal') {
                this.hideConfirm();
            }
        });
    }

    showProgress(title, callback) {
        const modal = document.getElementById('progressModal');
        const progressTitle = document.getElementById('progressTitle');
        const progressFill = document.getElementById('progressFill');
        const progressText = document.getElementById('progressText');

        progressTitle.textContent = title;
        progressText.textContent = 'Preparing...';
        progressFill.style.width = '0%';
        modal.classList.add('visible');

        let progress = 0;
        const interval = setInterval(() => {
            progress += Math.random() * 20;
            if (progress >= 100) {
                progress = 100;
                clearInterval(interval);
                setTimeout(() => {
                    modal.classList.remove('visible');
                    if (callback) callback();
                }, 500);
            }
            progressFill.style.width = progress + '%';
            progressText.textContent = this.getProgressText(progress);
        }, 300);
    }

    getProgressText(progress) {
        if (progress < 20) return 'Preparing...';
        if (progress < 40) return 'Processing files...';
        if (progress < 60) return 'Copying data...';
        if (progress < 80) return 'Finalizing...';
        return 'Almost done...';
    }

    showConfirm(text, onConfirm) {
        const modal = document.getElementById('confirmModal');
        const confirmText = document.getElementById('confirmText');
        
        confirmText.textContent = text;
        modal.classList.add('visible');

        document.getElementById('confirmActionBtn')?.addEventListener('click', () => {
            this.hideConfirm();
            if (onConfirm) onConfirm();
        }, { once: true });
    }

    hideConfirm() {
        document.getElementById('confirmModal')?.classList.remove('visible');
    }

    // Toggles
    setupToggles() {
        document.querySelectorAll('.setting-toggle').forEach(toggle => {
            toggle.addEventListener('change', () => {
                console.log('Setting changed');
            });
        });
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.installerSystem = new InstallerSystem();
});