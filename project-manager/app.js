// LinkUp Studio Project Manager - Main Application

class ProjectManager {
    constructor() {
        this.projects = this.loadProjects();
        this.currentView = 'all';
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupSearch();
        this.setupActions();
        this.setupKeyboardShortcuts();
        this.renderProjects();
    }

    loadProjects() {
        const stored = localStorage.getItem('linkup-projects');
        return stored ? JSON.parse(stored) : this.getDefaultProjects();
    }

    getDefaultProjects() {
        return [
            {
                id: 1,
                name: 'LinkUp-Studio',
                path: 'D:\\Projects\\LinkUp-Studio',
                type: 'node',
                branch: 'main',
                commits: 142,
                lastModified: new Date(Date.now() - 2 * 60 * 60 * 1000),
                favorite: false
            },
            {
                id: 2,
                name: 'DataAnalysis',
                path: 'D:\\Projects\\DataAnalysis',
                type: 'python',
                branch: 'main',
                commits: 28,
                lastModified: new Date(Date.now() - 24 * 60 * 60 * 1000),
                favorite: false
            },
            {
                id: 3,
                name: 'MyWebsite',
                path: 'D:\\Projects\\MyWebsite',
                type: 'react',
                branch: 'main',
                commits: 56,
                lastModified: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000),
                favorite: true
            },
            {
                id: 4,
                name: 'Backend-API',
                path: 'D:\\Projects\\Backend-API',
                type: 'docker',
                branch: 'develop',
                commits: 89,
                lastModified: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
                favorite: false
            }
        ];
    }

    saveProjects() {
        localStorage.setItem('linkup-projects', JSON.stringify(this.projects));
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.pm-nav-item');
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
        document.querySelectorAll('.pm-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });

        // Update views
        document.querySelectorAll('.pm-view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });

        this.currentView = viewName;
        this.renderProjects();
    }

    // Search
    setupSearch() {
        const searchInput = document.getElementById('searchInput');
        
        searchInput?.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            this.filterProjects(query);
        });
    }

    filterProjects(query) {
        const cards = document.querySelectorAll('.project-card');
        cards.forEach(card => {
            const name = card.querySelector('h3')?.textContent.toLowerCase() || '';
            const path = card.querySelector('.project-info p')?.textContent.toLowerCase() || '';
            const visible = !query || name.includes(query) || path.includes(query);
            card.style.display = visible ? 'block' : 'none';
        });
    }

    // Actions
    setupActions() {
        // New project button
        document.getElementById('newProjectBtn')?.addEventListener('click', () => this.addProject());
        document.getElementById('addProjectCard')?.addEventListener('click', () => this.addProject());

        // Favorite buttons
        document.querySelectorAll('.favorite-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.toggleFavorite(btn);
            });
        });

        // Action buttons
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const action = btn.title;
                if (action === 'Open in VS Code') this.openInVSCode(btn);
                if (action === 'Open in Terminal') this.openInTerminal(btn);
                if (action === 'Open') this.openProject(btn);
            });
        });

        // Project cards
        document.querySelectorAll('.project-card:not(.add-new)').forEach(card => {
            card.addEventListener('click', () => this.openProject(card));
        });
    }

    addProject() {
        const name = prompt('Project name:');
        if (name) {
            const path = prompt('Project path:', 'D:\\Projects\\');
            if (path) {
                const type = prompt('Project type (node, python, react, docker):', 'node');
                const project = {
                    id: Date.now(),
                    name,
                    path,
                    type: type || 'node',
                    branch: 'main',
                    commits: 0,
                    lastModified: new Date(),
                    favorite: false
                };
                this.projects.push(project);
                this.saveProjects();
                this.renderProjects();
            }
        }
    }

    toggleFavorite(btn) {
        const card = btn.closest('.project-card');
        const projectName = card.querySelector('h3')?.textContent;
        const project = this.projects.find(p => p.name === projectName);
        if (project) {
            project.favorite = !project.favorite;
            btn.classList.toggle('active', project.favorite);
            this.saveProjects();
        }
    }

    openProject(element) {
        const card = element.closest ? element.closest('.project-card') : element;
        const projectName = card.querySelector('h3')?.textContent;
        const project = this.projects.find(p => p.name === projectName);
        if (project) {
            console.log('Opening project:', project.path);
            // Would open in VS Code or terminal
        }
    }

    openInVSCode(btn) {
        const card = btn.closest('.project-card');
        const projectName = card.querySelector('h3')?.textContent;
        const project = this.projects.find(p => p.name === projectName);
        if (project) {
            console.log('Opening in VS Code:', project.path);
            // Would open in VS Code
        }
    }

    openInTerminal(btn) {
        const card = btn.closest('.project-card');
        const projectName = card.querySelector('h3')?.textContent;
        const project = this.projects.find(p => p.name === projectName);
        if (project) {
            console.log('Opening terminal in:', project.path);
            // Would open terminal
        }
    }

    // Keyboard Shortcuts
    setupKeyboardShortcuts() {
        document.addEventListener('keydown', (e) => {
            // Ctrl+P - Search
            if ((e.ctrlKey || e.metaKey) && e.key === 'p') {
                e.preventDefault();
                document.getElementById('searchInput')?.focus();
            }
            // Ctrl+N - New Project
            if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
                e.preventDefault();
                this.addProject();
            }
            // Escape - Clear search
            if (e.key === 'Escape') {
                const search = document.getElementById('searchInput');
                if (search) {
                    search.value = '';
                    this.filterProjects('');
                }
            }
        });
    }

    // Render
    renderProjects() {
        // This is handled by static HTML for demo
        // In real app, would dynamically render based on view
    }

    // Time formatting
    formatTimeAgo(date) {
        const seconds = Math.floor((new Date() - new Date(date)) / 1000);
        
        const intervals = [
            { label: 'year', seconds: 31536000 },
            { label: 'month', seconds: 2592000 },
            { label: 'week', seconds: 604800 },
            { label: 'day', seconds: 86400 },
            { label: 'hour', seconds: 3600 },
            { label: 'minute', seconds: 60 }
        ];
        
        for (const interval of intervals) {
            const count = Math.floor(seconds / interval.seconds);
            if (count >= 1) {
                return `${count} ${interval.label}${count > 1 ? 's' : ''} ago`;
            }
        }
        return 'Just now';
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.projectManager = new ProjectManager();
});
