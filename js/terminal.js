/**
 * LinkUp Studio - Terminal Component
 * Warp Terminal-inspired design
 */

class Terminal {
  constructor(options) {
    this.container = options.container;
    this.history = [];
    this.historyIndex = -1;
    this.currentInput = '';
    this.isMaximized = false;
    
    this.prompt = {
      user: 'user',
      host: 'linkup-studio',
      path: '~',
      symbol: '›'
    };
    
    this.init();
  }

  init() {
    this.render();
    this.bindEvents();
    this.addWelcomeMessage();
  }

  render() {
    this.container.innerHTML = `
      <div class="terminal-header">
        <div class="terminal-title">
          <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
            <path d="M0 3.5A1.5 1.5 0 011.5 2h13A1.5 1.5 0 0116 3.5v9a1.5 1.5 0 01-1.5 1.5h-13A1.5 1.5 0 010 12.5v-9zM1.5 3a.5.5 0 00-.5.5v9a.5.5 0 00.5.5h13a.5.5 0 00.5-.5v-9a.5.5 0 00-.5-.5h-13zM2 10l3.5 3.5L2 15h1.5l3.5-3.5L7 15H5.5L2 10zm9.5-3.5L9 10 5.5 6.5 9 3h1.5L6.5 7l3.5 3.5L13 6.5z"/>
          </svg>
          <span>Terminal</span>
        </div>
        <div class="terminal-tabs">
          <div class="terminal-tab active">bash</div>
          <div class="terminal-tab">zsh</div>
        </div>
        <div class="terminal-actions">
          <button class="btn-icon btn-ghost btn-sm terminal-action" data-action="clear" title="Clear">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
              <path d="M5 3.5h6A1.5 1.5 0 0112.5 5v6a1.5 1.5 0 01-1.5 1.5H5A1.5 1.5 0 013.5 11V5A1.5 1.5 0 015 3.5zM5 5h6v6H5V5z"/>
              <path d="M4.5 3l7 7M11.5 3l-7 7"/>
            </svg>
          </button>
          <button class="btn-icon btn-ghost btn-sm terminal-action" data-action="maximize" title="Maximize">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
              <path d="M4.5 2a.5.5 0 01.5-.5h10a.5.5 0 01.5.5v10a.5.5 0 01-.5.5h-10A.5.5 0 014 12v-10zm5.5 0v10h6V2h-6z"/>
            </svg>
          </button>
          <button class="btn-icon btn-ghost btn-sm terminal-action" data-action="close" title="Close">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
              <path d="M4.28 3.22a.75.75 0 00-1.06 1.06L6.94 8l-3.72 3.72a.75.75 0 101.06 1.06L8 9.06l3.72 3.72a.75.75 0 101.06-1.06L9.06 8l3.72-3.72a.75.75 0 00-1.06-1.06L8 6.94 4.28 3.22z"/>
            </svg>
          </button>
        </div>
      </div>
      <div class="terminal-body" id="terminal-body">
        <div class="terminal-output" id="terminal-output"></div>
        <div class="terminal-input-line">
          <span class="terminal-prompt-text">
            <span class="terminal-prompt-user">${this.prompt.user}</span>
            <span class="terminal-prompt-at">@</span>
            <span class="terminal-prompt-host">${this.prompt.host}</span>
            <span class="terminal-prompt-colon">:</span>
            <span class="terminal-prompt-path">${this.prompt.path}</span>
            <span class="terminal-prompt-symbol">${this.prompt.symbol}</span>
          </span>
          <input type="text" 
                 class="terminal-input" 
                 id="terminal-input" 
                 autocomplete="off" 
                 autocorrect="off"
                 autocapitalize="off"
                 spellcheck="false">
          <span class="terminal-cursor"></span>
        </div>
      </div>
    `;
    
    this.output = this.container.querySelector('#terminal-output');
    this.input = this.container.querySelector('#terminal-input');
    this.body = this.container.querySelector('#terminal-body');
    this.promptText = this.container.querySelector('.terminal-prompt-text');
  }

  bindEvents() {
    // Focus input when clicking anywhere in terminal
    this.body.addEventListener('click', () => {
      this.input.focus();
    });

    // Handle input
    this.input.addEventListener('keydown', (e) => {
      this.handleInput(e);
    });

    // Update cursor position
    this.input.addEventListener('input', () => {
      this.updateCursorPosition();
    });

    // Handle action buttons
    this.container.querySelectorAll('.terminal-action').forEach(btn => {
      btn.addEventListener('click', () => {
        const action = btn.dataset.action;
        switch (action) {
          case 'clear':
            this.clear();
            break;
          case 'maximize':
            this.toggleMaximize();
            break;
          case 'close':
            this.close();
            break;
        }
      });
    });

    // Handle tab switching
    this.container.querySelectorAll('.terminal-tab').forEach(tab => {
      tab.addEventListener('click', () => {
        this.container.querySelectorAll('.terminal-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
      });
    });
  }

  handleInput(e) {
    switch (e.key) {
      case 'Enter':
        e.preventDefault();
        this.executeCommand(this.input.value);
        this.input.value = '';
        this.currentInput = '';
        this.historyIndex = -1;
        break;
        
      case 'ArrowUp':
        e.preventDefault();
        this.navigateHistory('up');
        break;
        
      case 'ArrowDown':
        e.preventDefault();
        this.navigateHistory('down');
        break;
        
      case 'Tab':
        e.preventDefault();
        this.handleTabCompletion();
        break;
        
      case 'c':
        if (e.ctrlKey) {
          e.preventDefault();
          this.addLine('', 'command');
          this.input.value = '';
          this.currentInput = '';
        }
        break;
        
      case 'l':
        if (e.ctrlKey) {
          e.preventDefault();
          this.clear();
        }
        break;
    }
  }

  executeCommand(cmd) {
    // Add command to history
    this.history.push(cmd);
    this.historyIndex = -1;
    
    // Display the command
    this.addPromptLine(cmd);
    
    // Process the command
    const output = this.processCommand(cmd);
    
    // Display output if any
    if (output) {
      this.addLine(output, 'output');
    }
    
    // Scroll to bottom
    this.scrollToBottom();
  }

  processCommand(cmd) {
    const trimmed = cmd.trim();
    
    if (!trimmed) return '';
    
    const [command, ...args] = trimmed.split(/\s+/);
    
    switch (command.toLowerCase()) {
      case 'help':
        return this.showHelp();
        
      case 'clear':
      case 'cls':
        this.clear();
        return '';
        
      case 'echo':
        return args.join(' ');
        
      case 'pwd':
        return `/home/${this.prompt.user}/${this.prompt.path.replace('~', '')}`;
        
      case 'whoami':
        return this.prompt.user;
        
      case 'date':
        return new Date().toString();
        
      case 'ls':
        return this.listDirectory(args);
        
      case 'cd':
        if (args[0]) {
          if (args[0] === '..') {
            return '';
          } else if (args[0] === '~') {
            this.prompt.path = '~';
            this.updatePrompt();
            return '';
          } else {
            this.prompt.path = `~/${args[0]}`;
            this.updatePrompt();
            return '';
          }
        }
        return '';
        
      case 'cat':
        if (args[0]) {
          return `cat: ${args[0]}: This is a demo terminal`;
        }
        return '';
        
      case 'git':
        return this.handleGitCommand(args);
        
      case 'node':
      case 'npm':
      case 'python':
      case 'code':
        return `${command}: command available but not executed in demo mode`;
        
      case 'neofetch':
        return this.showNeofetch();
        
      default:
        return `bash: ${command}: command not found`;
    }
  }

  showHelp() {
    return `Available commands:
  help      - Show this help message
  clear     - Clear the terminal
  echo      - Print text to terminal
  pwd       - Print working directory
  whoami    - Display current user
  date      - Show current date/time
  ls        - List directory contents
  cd        - Change directory
  cat       - Display file contents
  git       - Git version control
  neofetch  - System information
  
Use ↑↓ arrows for command history.
Press Tab for auto-completion.`;
  }

  listDirectory(args) {
    const showHidden = args.includes('-a') || args.includes('-la') || args.includes('-al');
    const files = [
      { name: '.', type: 'dir', hidden: true },
      { name: '..', type: 'dir', hidden: true },
      { name: '.gitignore', type: 'file', hidden: true },
      { name: 'README.md', type: 'file' },
      { name: 'src', type: 'dir' },
      { name: 'node_modules', type: 'dir' },
      { name: 'package.json', type: 'file' },
      { name: 'styles.css', type: 'file' }
    ];
    
    const filtered = showHidden ? files : files.filter(f => !f.hidden);
    
    return filtered.map(f => {
      const name = f.type === 'dir' ? `\x1b[1;34m${f.name}/\x1b[0m` : f.name;
      return name;
    }).join('  ');
  }

  handleGitCommand(args) {
    if (args.length === 0) {
      return `git version 2.40.0`;
    }
    
    const [subcommand, ...rest] = args;
    
    switch (subcommand) {
      case 'status':
        return `On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean`;
        
      case 'log':
        return `commit a1b2c3d (HEAD -> main, origin/main)
Author: Developer <dev@example.com>
Date:   ${new Date().toDateString()}

    Initial commit`;
        
      case 'branch':
        return `* main`;
        
      case 'diff':
        return '';
        
      default:
        return `git: '${subcommand}' is not a git command`;
    }
  }

  showNeofetch() {
    return `
            ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
            █                                         █
            █   ▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄▄ ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄   █
            █   █   █ █ █ █ █ █ █   █ █   █ █   █   █
            █   █   █ █ █▄█ █ █ █▄▄▄ █   █ █   █   █
            █   █▄▄▄█ █ █ █ █ █ █▄▄▄ █▄▄▄█ █▄▄▄█   █
            █   ▀▀▀▀▀ ▀▀ ▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀▀   █
            █                                         █
            ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

  LinkUp Studio v1.0.0
  OS: Windows 10 Pro (64-bit)
  Host: LinkUp Studio
  Shell: bash 5.1.16
  Terminal: Warp-inspired Terminal
  Theme: GitHub Dark
  
  ████████████ 100%`;
  }

  addWelcomeMessage() {
    const welcome = `
\x1b[1;36m╔═══════════════════════════════════════════════════════════╗\x1b[0m
\x1b[1;36m║                                                           ║\x1b[0m
\x1b[1;36m║   \x1b[0m  ██████  ██████  ██████  ███████ ███    ██            \x1b[1;36m║\x1b[0m
\x1b[1;36m║   \x1b[0m  ██      ██    ██ ██   ██ ██      ████   ██            \x1b[1;36m║\x1b[0m
\x1b[1;36m║   \x1b[0m  ██  ▄▄▄ ██    ██ ██   ██ ███████ ██ ██  ██            \x1b[1;36m║\x1b[0m
\x1b[1;36m║   \x1b[0m  ██   ██ ██    ██ ██   ██      ██ ██  ██ ██            \x1b[1;36m║\x[1;0m
\x1b[1;36m║   \x1b[0m  ██████  ██████  ██████  ███████ ██   ████            \x1b[1;36m║\x1b[0m
\x1b[1;36m║                                                           ║\x1b[0m
\x1b[1;36m║   \x1b[0m          Premium Developer Environment             \x1b[1;36m║\x1b[0m
\x1b[1;36m║                                                           ║\x1b[0m
\x1b[1;36m╚═══════════════════════════════════════════════════════════╝\x1b[0m

Type \x1b[1;32m'help'\x1b[0m to see available commands.
`;
    this.addLine(welcome, 'welcome');
  }

  addPromptLine(cmd) {
    const line = document.createElement('div');
    line.className = 'terminal-line terminal-command-line';
    line.innerHTML = `
      <span class="terminal-prompt-line">
        <span class="terminal-prompt-user">${this.prompt.user}</span>
        <span class="terminal-prompt-at">@</span>
        <span class="terminal-prompt-host">${this.prompt.host}</span>
        <span class="terminal-prompt-colon">:</span>
        <span class="terminal-prompt-path">${this.prompt.path}</span>
        <span class="terminal-prompt-symbol">${this.prompt.symbol}</span>
      </span>
      <span class="terminal-command">${this.escapeHtml(cmd)}</span>
    `;
    this.output.appendChild(line);
  }

  addLine(content, type = 'output') {
    const line = document.createElement('div');
    line.className = `terminal-line terminal-${type}`;
    
    if (type === 'welcome') {
      line.innerHTML = `<pre class="terminal-welcome">${content}</pre>`;
    } else if (type === 'output') {
      line.innerHTML = `<span class="terminal-output-text">${this.formatOutput(content)}</span>`;
    } else {
      line.textContent = content;
    }
    
    this.output.appendChild(line);
  }

  formatOutput(text) {
    // Simple ANSI color code handling
    return text
      .replace(/\x1b\[1;32m/g, '<span style="color: var(--success-fg); font-weight: bold;">')
      .replace(/\x1b\[1;34m/g, '<span style="color: var(--accent-fg); font-weight: bold;">')
      .replace(/\x1b\[1;36m/g, '<span style="color: var(--text-primary); font-weight: bold;">')
      .replace(/\x1b\[0m/g, '</span>')
      .replace(/\n/g, '<br>');
  }

  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  updatePrompt() {
    const promptLine = this.container.querySelector('.terminal-prompt-text');
    const promptLineInCommand = this.container.querySelector('.terminal-prompt-line');
    
    const newPrompt = `
      <span class="terminal-prompt-user">${this.prompt.user}</span>
      <span class="terminal-prompt-at">@</span>
      <span class="terminal-prompt-host">${this.prompt.host}</span>
      <span class="terminal-prompt-colon">:</span>
      <span class="terminal-prompt-path">${this.prompt.path}</span>
      <span class="terminal-prompt-symbol">${this.prompt.symbol}</span>
    `;
    
    if (promptLine) promptLine.innerHTML = newPrompt;
    if (promptLineInCommand) promptLineInCommand.innerHTML = newPrompt;
  }

  navigateHistory(direction) {
    if (this.history.length === 0) return;
    
    if (direction === 'up') {
      if (this.historyIndex === -1) {
        this.currentInput = this.input.value;
      }
      this.historyIndex = Math.min(this.historyIndex + 1, this.history.length - 1);
    } else {
      this.historyIndex = Math.max(this.historyIndex - 1, -1);
    }
    
    this.input.value = this.historyIndex === -1 ? this.currentInput : this.history[this.history.length - 1 - this.historyIndex];
    this.updateCursorPosition();
  }

  handleTabCompletion() {
    const commands = ['help', 'clear', 'echo', 'pwd', 'whoami', 'date', 'ls', 'cd', 'cat', 'git', 'neofetch'];
    const input = this.input.value.toLowerCase();
    
    if (!input) return;
    
    const matches = commands.filter(c => c.startsWith(input));
    
    if (matches.length === 1) {
      this.input.value = matches[0] + ' ';
    } else if (matches.length > 1) {
      this.addLine(matches.join('  '), 'output');
      this.scrollToBottom();
    }
  }

  updateCursorPosition() {
    // Create a hidden span to measure text width
    const measure = document.createElement('span');
    measure.style.cssText = `
      font-family: var(--font-mono);
      font-size: var(--text-sm);
      visibility: hidden;
      position: absolute;
      white-space: pre;
    `;
    measure.textContent = this.input.value;
    document.body.appendChild(measure);
    
    const inputWidth = this.input.offsetWidth;
    const textWidth = measure.offsetWidth;
    
    document.body.removeChild(measure);
    
    // Adjust input scroll if needed
    if (textWidth > inputWidth - 20) {
      this.input.scrollLeft = textWidth - inputWidth + 40;
    }
  }

  scrollToBottom() {
    this.body.scrollTop = this.body.scrollHeight;
  }

  clear() {
    this.output.innerHTML = '';
  }

  toggleMaximize() {
    this.isMaximized = !this.isMaximized;
    this.container.style.height = this.isMaximized ? '50vh' : '200px';
  }

  close() {
    this.container.style.display = 'none';
  }

  show() {
    this.container.style.display = 'flex';
  }
}