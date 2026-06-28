/**
 * LinkUp Studio - Command Palette
 * Raycast-inspired command interface
 */

class CommandPalette {
  constructor(options) {
    this.container = options.container;
    this.onSelect = options.onSelect || (() => {});
    
    this.commands = this.getDefaultCommands();
    this.selectedIndex = 0;
    this.filteredCommands = [...this.commands];
    
    this.init();
  }

  getDefaultCommands() {
    return [
      // File Commands
      {
        id: 'new-file',
        group: 'File',
        label: 'New File',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M4 1.5H3a2 2 0 00-2 2V14a2 2 0 002 2h10a2 2 0 002-2V3.5a2 2 0 00-2-2h-1v1h1a1 1 0 011 1V14a1 1 0 01-1 1H3a1 1 0 01-1-1V3.5a1 1 0 011-1h1v-1z"/><path d="M9.5 1a.5.5 0 01.5.5v1a.5.5 0 01-.5.5h-3a.5.5 0 01-.5-.5v-1a.5.5 0 01.5-.5h3zm-3-1A1.5 1.5 0 005 1.5v1A1.5 1.5 0 006.5 4h3A1.5 1.5 0 0011 2.5v-1A1.5 1.5 0 009.5 0h-3z"/></svg>',
        shortcut: 'Ctrl+N',
        action: () => this.onSelect({ id: 'new-file' })
      },
      {
        id: 'open-folder',
        group: 'File',
        label: 'Open Folder',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M1 3.5A1.5 1.5 0 012.5 2h2.764c.958 0 1.76.56 2.311 1.184C7.985 3.648 8.48 4 9 4h4.5A1.5 1.5 0 0115 5.5v.64c.57.265.94.876.856 1.546l-.64 5.124A2.5 2.5 0 0112.733 15H3.266a2.5 2.5 0 01-2.481-2.19l-.64-5.124A1.5 1.5 0 011 3.5V3.5z"/><path d="M3.266 13.5H2.5a.5.5 0 00-.5.5v.5h11v-.5a.5.5 0 00-.5-.5h-11z"/></svg>',
        shortcut: 'Ctrl+O',
        action: () => this.onSelect({ id: 'open-folder' })
      },
      {
        id: 'save',
        group: 'File',
        label: 'Save',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M4 1.5H3a2 2 0 00-2 2V14a2 2 0 002 2h10a2 2 0 002-2V3.5a2 2 0 00-2-2h-1v1h1a1 1 0 011 1V14a1 1 0 01-1 1H3a1 1 0 01-1-1V3.5a1 1 0 011-1h1v-1z"/><path d="M9.5 1a.5.5 0 01.5.5v1a.5.5 0 01-.5.5h-3a.5.5 0 01-.5-.5v-1a.5.5 0 01.5-.5h3zm-3-1A1.5 1.5 0 005 1.5v1A1.5 1.5 0 006.5 4h3A1.5 1.5 0 0011 2.5v-1A1.5 1.5 0 009.5 0h-3z"/><path d="M3 2.5a.5.5 0 01.5-.5h5a.5.5 0 010 1h-5a.5.5 0 01-.5-.5zm0 2a.5.5 0 01.5-.5h5a.5.5 0 010 1h-5a.5.5 0 01-.5-.5zm0 2a.5.5 0 01.5-.5h5a.5.5 0 010 1h-5a.5.5 0 01-.5-.5zm0 2a.5.5 0 01.5-.5h3a.5.5 0 010 1h-3a.5.5 0 01-.5-.5z"/></svg>',
        shortcut: 'Ctrl+S',
        action: () => this.onSelect({ id: 'save' })
      },
      {
        id: 'save-all',
        group: 'File',
        label: 'Save All',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M2 1a1 1 0 00-1 1v1a1 1 0 001 1H3v2H2a1 1 0 00-1 1v8a1 1 0 001 1h12a1 1 0 001-1V5a1 1 0 00-1-1h-1V3a1 1 0 00-1-1H2zm10 1H4v12h8V2zm-7 4a1 1 0 100 2 1 1 0 000-2z"/></svg>',
        shortcut: 'Ctrl+Shift+S',
        action: () => this.onSelect({ id: 'save-all' })
      },
      {
        id: 'close-editor',
        group: 'File',
        label: 'Close Editor',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M4.28 3.22a.75.75 0 00-1.06 1.06L6.94 8l-3.72 3.72a.75.75 0 101.06 1.06L8 9.06l3.72 3.72a.75.75 0 101.06-1.06L9.06 8l3.72-3.72a.75.75 0 00-1.06-1.06L8 6.94 4.28 3.22z"/></svg>',
        shortcut: 'Ctrl+W',
        action: () => this.onSelect({ id: 'close-editor' })
      },
      
      // Edit Commands
      {
        id: 'undo',
        group: 'Edit',
        label: 'Undo',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8.75 3.75a.75.75 0 00-1.5 0v3.5a.75.75 0 001.5 0v-3.5zm4.75 8.75a.75.75 0 01-1.5 0v-5.5a.75.75 0 011.5 0v5.5zm-9-1.5h7.5A2.25 2.25 0 0113.5 11.25V13a.75.75 0 01-1.5 0v-1.75A.75.75 0 0111 11.25H3.5a.75.75 0 010-1.5H11V5.5a.75.75 0 011.5 0v3.75A2.25 2.25 0 0110.25 12z"/></svg>',
        shortcut: 'Ctrl+Z',
        action: () => this.onSelect({ id: 'undo' })
      },
      {
        id: 'redo',
        group: 'Edit',
        label: 'Redo',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M7.25 3.75a.75.75 0 011.5 0v3.5a.75.75 0 01-1.5 0v-3.5zm-4.75 8.75a.75.75 0 011.5 0v-5.5a.75.75 0 01-1.5 0v5.5zm8-1.5h-7.5A2.25 2.25 0 012.5 9.75V8a.75.75 0 011.5 0v1.75a.75.75 0 001.5 0V5.5a.75.75 0 011.5 0v3.75A2.25 2.25 0 0110.75 12H5.5a.75.75 0 010-1.5H10V5.5a.75.75 0 011.5 0v3.75A2.25 2.25 0 0113.5 10.5z"/></svg>',
        shortcut: 'Ctrl+Y',
        action: () => this.onSelect({ id: 'redo' })
      },
      {
        id: 'find',
        group: 'Edit',
        label: 'Find',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M10.68 11.74a6 6 0 01-7.922-8.982 6 6 0 118.982 7.922l3.04 3.04a.749.749 0 101.06-1.06l-3.04-3.04zM11.5 7a4.499 4.499 0 11-8.997 0A4.499 4.499 0 0111.5 7z"/></svg>',
        shortcut: 'Ctrl+F',
        action: () => this.onSelect({ id: 'find' })
      },
      {
        id: 'replace',
        group: 'Edit',
        label: 'Find and Replace',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 5a1.5 1.5 0 100 3 1.5 1.5 0 000-3zM8 0a8 8 0 1016 0A8 8 0 008 0zm4.97 9.03a.749.749 0 01.107 1.047l.08.1 2.12 2.122a.749.749 0 11-1.06 1.06l-.1-.08-2.12-2.121a.75.75 0 01.988-1.047l.083.07zm-9.94 0a.75.75 0 01-.105-1.047l.08-.1-2.12-2.122a.75.75 0 111.06-1.06l.1.08 2.12 2.121a.75.75 0 01-1.135.99l-.02-.02z"/></svg>',
        shortcut: 'Ctrl+H',
        action: () => this.onSelect({ id: 'replace' })
      },
      
      // View Commands
      {
        id: 'toggle-terminal',
        group: 'View',
        label: 'Toggle Terminal',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M0 3.5A1.5 1.5 0 011.5 2h13A1.5 1.5 0 0116 3.5v9a1.5 1.5 0 01-1.5 1.5h-13A1.5 1.5 0 010 12.5v-9zM1.5 3a.5.5 0 00-.5.5v9a.5.5 0 00.5.5h13a.5.5 0 00.5-.5v-9a.5.5 0 00-.5-.5h-13zM2 10l3.5 3.5L2 15h1.5l3.5-3.5L7 15H5.5L2 10zm9.5-3.5L9 10 5.5 6.5 9 3h1.5L6.5 7l3.5 3.5L13 6.5z"/></svg>',
        shortcut: 'Ctrl+`',
        action: () => this.onSelect({ id: 'toggle-terminal' })
      },
      {
        id: 'toggle-sidebar',
        group: 'View',
        label: 'Toggle Sidebar',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M0 1.75C0 .784.784 0 1.75 0h12.5C15.216 0 16 .784 16 1.75v12.5A1.75 1.75 0 0114.25 16H1.75A1.75 1.75 0 010 14.25V1.75zm1.75-.25a.25.25 0 00-.25.25v12.5c0 .138.112.25.25.25h12.5a.25.25 0 00.25-.25V1.75a.25.25 0 00-.25-.25H1.75z"/></svg>',
        shortcut: 'Ctrl+B',
        action: () => this.onSelect({ id: 'toggle-sidebar' })
      },
      {
        id: 'toggle-activity',
        group: 'View',
        label: 'Toggle Activity Panel',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M5 3.254V3.25v.005a.75.75 0 110-.005v.004zm.45 1.9a2.25 2.25 0 10-1.95.218v5.256a2.25 2.25 0 101.5 0V7.123A5.735 5.735 0 009.25 9h1.378a2.251 2.251 0 100-1.5H9.25a4.25 4.25 0 01-3.8-2.346zM12.75 9a.75.75 0 100-1.5.75.75 0 000 1.5zm-8.5 4.5a.75.75 0 100-1.5.75.75 0 000 1.5z"/></svg>',
        shortcut: 'Ctrl+Shift+A',
        action: () => this.onSelect({ id: 'toggle-activity' })
      },
      {
        id: 'zoom-in',
        group: 'View',
        label: 'Zoom In',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M6.5 12a5.5 5.5 0 100-11 5.5 5.5 0 000 11zM13 12h3m-3 3V9m3 6h-3m3 3v-3m-3-6h3m3 3v-3M0 8a8 8 0 1116 0A8 8 0 010 8z"/></svg>',
        shortcut: 'Ctrl+=',
        action: () => this.onSelect({ id: 'zoom-in' })
      },
      {
        id: 'zoom-out',
        group: 'View',
        label: 'Zoom Out',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M6.5 12a5.5 5.5 0 100-11 5.5 5.5 0 000 11zM13 12H3m3-6V3m0 3v3m0 0H3"/></svg>',
        shortcut: 'Ctrl+-',
        action: () => this.onSelect({ id: 'zoom-out' })
      },
      {
        id: 'reset-zoom',
        group: 'View',
        label: 'Reset Zoom',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M9.156 6.953a4.5 4.5 0 01-6.312 0 4.5 4.5 0 010-6.312A4.5 4.5 0 019.156 6.953zM3.5 9.75a.75.75 0 000 1.5 8.002 8.002 0 0115.356 2.638.75.75 0 001.06-1.06 9.5 9.5 0 00-16.416-3.078z"/><path d="M9.156 9.047a4.5 4.5 0 016.312 0 4.5 4.5 0 010 6.312 4.5 4.5 0 01-6.312 0z"/></svg>',
        shortcut: 'Ctrl+0',
        action: () => this.onSelect({ id: 'reset-zoom' })
      },
      
      // Git Commands
      {
        id: 'git-commit',
        group: 'Git',
        label: 'Commit',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M10.5 7.75a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0zm1.43.75a4.002 4.002 0 01-7.86 0H.75a.75.75 0 110-1.5h3.32a4.001 4.001 0 017.86 0h3.32a.75.75 0 110 1.5h-3.32z"/></svg>',
        shortcut: 'Ctrl+Enter',
        action: () => this.onSelect({ id: 'git-commit' })
      },
      {
        id: 'git-push',
        group: 'Git',
        label: 'Push',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M2.5 3.5a.5.5 0 100-1 .5.5 0 000 1zm1.5 1.5a.5.5 0 100-1 .5.5 0 000 1zm-1.5.5a.5.5 0 11-1 0 .5.5 0 011 0zM3 8a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 003 8zm8 0a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 0011 8zm-4 2a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 007 10zm8-1a.5.5 0 01.5-.5H15v1.5a.5.5 0 01-1 0V8.5h-1.5A.5.5 0 0111 8zm-4 2a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 007 10zm4 0a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 0011 10zm-4 2a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 007 10z"/></svg>',
        action: () => this.onSelect({ id: 'git-push' })
      },
      {
        id: 'git-pull',
        group: 'Git',
        label: 'Pull',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M2.5 3.5a.5.5 0 100-1 .5.5 0 000 1zm1.5 1.5a.5.5 0 100-1 .5.5 0 000 1zm-1.5.5a.5.5 0 11-1 0 .5.5 0 011 0zM3 8a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 003 8zm8 0a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 0011 8zm-4 2a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5A.5.5 0 007 10zm8 0a.5.5 0 00-.5.5v1.5a.5.5 0 001 0v-1.5a.5.5 0 00-.5-.5z"/></svg>',
        action: () => this.onSelect({ id: 'git-pull' })
      },
      
      // Preferences
      {
        id: 'settings',
        group: 'Preferences',
        label: 'Open Settings',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 4.754a3.246 3.246 0 100 6.492 3.246 3.246 0 000-6.492zM5.754 8a2.246 2.246 0 114.492 0 2.246 2.246 0 01-4.492 0z"/><path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 01-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 01-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 01.52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 011.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 011.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 01.52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 01-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 01-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 002.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 001.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 00-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 00-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 00-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 001.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 003.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 002.692-1.115l.094-.319z"/></svg>',
        shortcut: 'Ctrl+,',
        action: () => this.onSelect({ id: 'settings' })
      },
      {
        id: 'keyboard-shortcuts',
        group: 'Preferences',
        label: 'Keyboard Shortcuts',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M0 4a2 2 0 012-2h12a2 2 0 012 2v8a2 2 0 01-2 2H2a2 2 0 01-2-2V4zm2-1a1 1 0 00-1 1v8a1 1 0 001 1h12a1 1 0 001-1V4a1 1 0 00-1-1H2zm9 9H3V4h8v4zm0 1v2H3v-2h8z"/></svg>',
        shortcut: 'Ctrl+K Ctrl+S',
        action: () => this.onSelect({ id: 'keyboard-shortcuts' })
      },
      {
        id: 'themes',
        group: 'Preferences',
        label: 'Color Theme',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 12a4 4 0 100-8 4 4 0 000 8zm0 1a5 5 0 100-10 5 5 0 000 10zm6.5-3.5a.5.5 0 00-1 0v.088a.5.5 0 00.237.427l.973.486a.5.5 0 00.553-.894l-.973-.486A.5.5 0 0014.5 10.5V9z"/></svg>',
        action: () => this.onSelect({ id: 'themes' })
      },
      
      // Help
      {
        id: 'about',
        group: 'Help',
        label: 'About LinkUp Studio',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 15A7 7 0 118 1a7 7 0 010 14zm0 1A8 8 0 108 0a8 8 0 000 16z"/><path d="M8.93 6.588l-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.174a1 1 0 11-2 0 1 1 0 012 0z"/></svg>',
        action: () => this.onSelect({ id: 'about' })
      },
      {
        id: 'documentation',
        group: 'Help',
        label: 'Documentation',
        icon: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M14.5 3H7.71l-.853 1.706A.25.25 0 006.736 5H1.5A1.5 1.5 0 000 6.5v5A1.5 1.5 0 001.5 13h13a1.5 1.5 0 001.5-1.5v-5A1.5 1.5 0 0014.5 3zM5.71 7.75A.25.25 0 015.46 8h5.08a.25.25 0 01.177.073l.973.487.007-.015V5.5a.5.5 0 00-.5-.5h-5a.5.5 0 00-.5.5v.25z"/></svg>',
        action: () => this.onSelect({ id: 'documentation' })
      }
    ];
  }

  init() {
    this.render();
    this.bindEvents();
  }

  render() {
    this.container.innerHTML = `
      <div class="command-palette">
        <div class="command-palette-input-wrapper">
          <svg viewBox="0 0 16 16" fill="currentColor">
            <path d="M10.68 11.74a6 6 0 01-7.922-8.982 6 6 0 118.982 7.922l3.04 3.04a.749.749 0 101.06-1.06l-3.04-3.04zM11.5 7a4.499 4.499 0 11-8.997 0A4.499 4.499 0 0111.5 7z"/>
          </svg>
          <input type="text" 
                 class="command-palette-input" 
                 placeholder="Type a command or search..." 
                 autocomplete="off"
                 id="command-palette-input">
        </div>
        <div class="command-palette-results" id="command-palette-results">
          ${this.renderResults()}
        </div>
        <div class="command-palette-footer">
          <div class="command-palette-hint">
            <span class="command-palette-hint-item">
              <kbd>↑↓</kbd> Navigate
            </span>
            <span class="command-palette-hint-item">
              <kbd>↵</kbd> Select
            </span>
            <span class="command-palette-hint-item">
              <kbd>Esc</kbd> Close
            </span>
          </div>
        </div>
      </div>
    `;
    
    this.input = this.container.querySelector('#command-palette-input');
    this.results = this.container.querySelector('#command-palette-results');
  }

  renderResults() {
    const grouped = this.groupByCategory(this.filteredCommands);
    let html = '';
    
    for (const [group, commands] of Object.entries(grouped)) {
      html += `
        <div class="command-palette-group">
          <div class="command-palette-group-title">${group}</div>
          ${commands.map((cmd, idx) => `
            <div class="command-palette-item" data-index="${this.commands.indexOf(cmd)}">
              <span class="command-palette-item-icon">${cmd.icon}</span>
              <span class="command-palette-item-text">${cmd.label}</span>
              ${cmd.shortcut ? `<span class="command-palette-item-shortcut"><kbd>${cmd.shortcut}</kbd></span>` : ''}
            </div>
          `).join('')}
        </div>
      `;
    }
    
    return html || '<div class="empty-state"><div class="empty-state-title">No results found</div></div>';
  }

  groupByCategory(commands) {
    return commands.reduce((acc, cmd) => {
      if (!acc[cmd.group]) acc[cmd.group] = [];
      acc[cmd.group].push(cmd);
      return acc;
    }, {});
  }

  bindEvents() {
    // Input handling
    this.container.addEventListener('input', (e) => {
      if (e.target === this.input) {
        this.filter(e.target.value);
      }
    });

    // Keyboard navigation
    this.container.addEventListener('keydown', (e) => {
      this.handleKeydown(e);
    });

    // Click handling
    this.container.addEventListener('click', (e) => {
      const item = e.target.closest('.command-palette-item');
      if (item) {
        const index = parseInt(item.dataset.index);
        this.selectItem(index);
      }
    });
  }

  filter(query) {
    if (!query.trim()) {
      this.filteredCommands = [...this.commands];
    } else {
      const q = query.toLowerCase();
      this.filteredCommands = this.commands.filter(cmd => 
        cmd.label.toLowerCase().includes(q) ||
        cmd.group.toLowerCase().includes(q) ||
        cmd.id.toLowerCase().includes(q)
      );
    }
    
    this.selectedIndex = 0;
    this.results.innerHTML = this.renderResults();
    this.updateSelection();
  }

  handleKeydown(e) {
    switch (e.key) {
      case 'ArrowDown':
        e.preventDefault();
        this.selectedIndex = Math.min(this.selectedIndex + 1, this.filteredCommands.length - 1);
        this.updateSelection();
        break;
        
      case 'ArrowUp':
        e.preventDefault();
        this.selectedIndex = Math.max(this.selectedIndex - 1, 0);
        this.updateSelection();
        break;
        
      case 'Enter':
        e.preventDefault();
        this.selectItem(this.selectedIndex);
        break;
        
      case 'Escape':
        e.preventDefault();
        this.close();
        break;
    }
  }

  updateSelection() {
    const items = this.results.querySelectorAll('.command-palette-item');
    items.forEach((item, idx) => {
      item.classList.toggle('selected', idx === this.selectedIndex);
    });
    
    // Scroll into view
    const selected = items[this.selectedIndex];
    if (selected) {
      selected.scrollIntoView({ block: 'nearest' });
    }
  }

  selectItem(index) {
    const command = this.filteredCommands[index];
    if (command && command.action) {
      command.action();
    }
  }

  focus() {
    if (this.input) {
      this.input.value = '';
      this.filter('');
      this.input.focus();
    }
  }

  close() {
    this.container.classList.remove('open');
  }
}