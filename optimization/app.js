// LinkUp Studio Optimization - Main Application

class OptimizationApp {
    constructor() {
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupToggles();
        this.setupActions();
        this.updateMetrics();
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.opt-nav-item');
        navItems.forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                const section = item.dataset.section;
                this.switchSection(section);
            });
        });
    }

    switchSection(sectionName) {
        document.querySelectorAll('.opt-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.section === sectionName);
        });
        document.querySelectorAll('.opt-section').forEach(section => {
            section.classList.toggle('active', section.id === `${sectionName}-section`);
        });
    }

    // Toggles
    setupToggles() {
        document.querySelectorAll('.setting-toggle').forEach(toggle => {
            toggle.addEventListener('change', (e) => {
                console.log('Toggle changed:', e.target.checked);
            });
        });
    }

    // Actions
    setupActions() {
        // Memory optimization
        document.querySelectorAll('.memory-actions .action-card').forEach(card => {
            card.addEventListener('click', () => {
                const action = card.querySelector('h3')?.textContent;
                this.executeOptimization(action);
            });
        });

        // Optimization tips
        document.querySelectorAll('.tip-content .btn-secondary').forEach(btn => {
            btn.addEventListener('click', () => {
                alert('Optimization applied!');
            });
        });
    }

    executeOptimization(action) {
        if (action.includes('Memory Cache')) {
            alert('Clearing memory cache...');
        } else if (action.includes('Browser Cache')) {
            alert('Clearing browser cache...');
        } else if (action.includes('Memory Limit')) {
            alert('Setting memory limit...');
        }
    }

    // Update Metrics
    updateMetrics() {
        // Simulate real-time updates
        setInterval(() => {
            this.updateCPU();
            this.updateMemory();
            this.updateDisk();
            this.updateNetwork();
        }, 3000);
    }

    updateCPU() {
        const value = Math.floor(Math.random() * 30 + 5);
        const bars = document.querySelectorAll('#performance-section .chart-bars .chart-bar');
        if (bars.length > 0) {
            bars.forEach(bar => {
                bar.style.height = (Math.random() * 60 + 20) + '%';
            });
        }
    }

    updateMemory() {
        const value = Math.floor(Math.random() * 200 + 400);
        console.log('Memory:', value + ' MB');
    }

    updateDisk() {
        const value = Math.floor(Math.random() * 20 + 2);
        console.log('Disk I/O:', value + ' MB/s');
    }

    updateNetwork() {
        const down = (Math.random() * 2 + 0.5).toFixed(1);
        const up = (Math.random() * 1 + 0.3).toFixed(1);
        console.log('Network:', down + ' MB/s down, ' + up + ' MB/s up');
    }
}

// Memory optimization function
function optimizeMemory() {
    alert('Optimizing memory...');
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.optimizationApp = new OptimizationApp();
});