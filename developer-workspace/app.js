// LinkUp Studio Developer Workspace - Main Application

class DeveloperWorkspace {
    constructor() {
        this.currentView = 'docker';
        this.terminalHistory = [];
        
        this.init();
    }

    init() {
        this.setupNavigation();
        this.setupDocker();
        this.setupNodeJS();
        this.setupPython();
        this.setupDatabases();
        this.setupTerminal();
    }

    // Navigation
    setupNavigation() {
        const navItems = document.querySelectorAll('.dev-nav-item');
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
        document.querySelectorAll('.dev-nav-item').forEach(item => {
            item.classList.toggle('active', item.dataset.view === viewName);
        });

        // Update views
        document.querySelectorAll('.dev-view').forEach(view => {
            view.classList.toggle('active', view.id === `${viewName}-view`);
        });

        this.currentView = viewName;
    }

    // Docker
    setupDocker() {
        document.getElementById('refreshDockerBtn')?.addEventListener('click', () => {
            this.refreshDocker();
        });

        document.getElementById('newContainerBtn')?.addEventListener('click', () => {
            this.createContainer();
        });
    }

    refreshDocker() {
        console.log('Refreshing Docker...');
        // Would call Docker API
    }

    createContainer() {
        const image = prompt('Image name:', 'nginx:latest');
        if (image) {
            console.log('Creating container from:', image);
            // Would call Docker API
        }
    }

    // Node.js
    setupNodeJS() {
        document.getElementById('newNodeProjectBtn')?.addEventListener('click', () => {
            this.createNodeProject();
        });

        document.getElementById('installNpmBtn')?.addEventListener('click', () => {
            this.installNpmPackage();
        });

        // Setup script run buttons
        document.querySelectorAll('.script-item .btn-icon-small').forEach(btn => {
            btn.addEventListener('click', () => {
                const scriptItem = btn.closest('.script-item');
                const scriptName = scriptItem.querySelector('.script-name').textContent;
                this.runNpmScript(scriptName);
            });
        });
    }

    createNodeProject() {
        const name = prompt('Project name:');
        if (name) {
            console.log('Creating Node.js project:', name);
            // Would create project
        }
    }

    installNpmPackage() {
        const input = document.getElementById('npmPackageInput');
        const packageName = input?.value.trim();
        if (packageName) {
            console.log('Installing npm package:', packageName);
            input.value = '';
            // Would install package
        }
    }

    runNpmScript(scriptName) {
        console.log('Running npm script:', scriptName);
        // Would run npm script
    }

    // Python
    setupPython() {
        document.getElementById('newVenvBtn')?.addEventListener('click', () => {
            this.createVenv();
        });

        document.getElementById('installPipBtn')?.addEventListener('click', () => {
            this.installPipPackage();
        });
    }

    createVenv() {
        const name = prompt('Environment name:', 'myenv');
        if (name) {
            console.log('Creating virtual environment:', name);
            // Would create venv
        }
    }

    installPipPackage() {
        const input = document.getElementById('pipPackageInput');
        const packageName = input?.value.trim();
        if (packageName) {
            console.log('Installing pip package:', packageName);
            input.value = '';
            // Would install package
        }
    }

    // Databases
    setupDatabases() {
        document.getElementById('newDbBtn')?.addEventListener('click', () => {
            this.addDatabase();
        });

        // Setup database card buttons
        document.querySelectorAll('.database-card .btn-primary').forEach(btn => {
            btn.addEventListener('click', () => {
                const card = btn.closest('.database-card');
                const dbType = card.querySelector('.db-type').textContent;
                this.openDatabase(dbType);
            });
        });
    }

    addDatabase() {
        const type = prompt('Database type (postgres, redis, mongodb):', 'postgres');
        if (type) {
            console.log('Adding database:', type);
            // Would add database connection
        }
    }

    openDatabase(type) {
        console.log('Opening database:', type);
        // Would open database editor
    }

    // Terminal
    setupTerminal() {
        const terminalInput = document.getElementById('terminalInput');
        
        terminalInput?.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                const command = terminalInput.value.trim();
                if (command) {
                    this.executeCommand(command);
                    terminalInput.value = '';
                }
            }
        });

        // Terminal tabs
        document.querySelectorAll('.terminal-tab').forEach(tab => {
            tab.addEventListener('click', () => {
                document.querySelectorAll('.terminal-tab').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
            });
        });
    }

    executeCommand(command) {
        const output = document.getElementById('terminalOutput');
        
        // Add command to history
        this.terminalHistory.push(command);

        // Echo command
        const cmdLine = document.createElement('div');
        cmdLine.className = 'terminal-line';
        cmdLine.innerHTML = `<span class="prompt">$</span> ${this.escapeHtml(command)}`;
        output.appendChild(cmdLine);

        // Simulate output
        const resultLine = document.createElement('div');
        resultLine.className = 'terminal-line';
        
        const lower = command.toLowerCase();
        if (lower.startsWith('docker')) {
            resultLine.textContent = 'Docker command executed successfully';
        } else if (lower.startsWith('npm') || lower.startsWith('npx')) {
            resultLine.textContent = 'npm command executed';
        } else if (lower.startsWith('pip') || lower.startsWith('python')) {
            resultLine.textContent = 'Python command executed';
        } else if (lower === 'ls' || lower === 'dir') {
            resultLine.textContent = 'README.md  SPEC.md  launcher/  shell/  ai-workspace/';
        } else if (lower === 'pwd') {
            resultLine.textContent = 'D:\\Projects\\LinkUp-Studio';
        } else if (lower === 'clear' || lower === 'cls') {
            output.innerHTML = '';
        } else if (lower === 'help') {
            resultLine.innerHTML = 'Available commands: docker, npm, pip, ls, dir, pwd, clear, cls, help';
        } else {
            resultLine.textContent = `Command not found: ${command}`;
            resultLine.style.color = 'var(--danger-fg)';
        }
        
        output.appendChild(resultLine);

        // Add new prompt
        const newPrompt = document.createElement('div');
        newPrompt.className = 'terminal-line prompt';
        newPrompt.innerHTML = 'PS D:\\Projects\\LinkUp-Studio> <span class="cursor">█</span>';
        output.appendChild(newPrompt);

        // Scroll to bottom
        output.parentElement.scrollTop = output.parentElement.scrollHeight;
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    window.devWorkspace = new DeveloperWorkspace();
});
