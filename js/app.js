/**
 * LinkUp Studio - Main Application
 * Premium Windows Developer Environment
 */

class LinkUpStudio {
  constructor() {
    this.isInitialized = false;
    this.activeView = 'explorer';
    this.isActivityPanelOpen = true;
    this.commandPaletteOpen = false;
    this.files = [];
    this.activeFile = null;
    
    this.init();
  }

  init() {
    if (this.isInitialized) return;
    
    this.cacheElements();
    this.bindEvents();
    this.initSidebar();
    this.initCommandPalette();
    this.initTerminal();
    this.initActivityPanel();
    this.initWindowControls();
    
    this.isInitialized = true;
    console.log('LinkUp Studio initialized');
  }

  cacheElements() {
    // Layout elements
    this.elements = {
      app: document.getElementById('app'),
      sidebar: document.querySelector('.sidebar'),
      sidebarItems: document.querySelectorAll('.sidebar-item'),
      mainContent: document.querySelector('.main-content'),
      tabBar: document.querySelector('.tab-bar'),
      editorArea: document.querySelector('.editor-area'),
      welcomeScreen: document.querySelector('.welcome-screen'),
      activityPanel: document.querySelector('.activity-panel'),
      statusbar: document.querySelector('.statusbar'),
      terminal: document.querySelector('.terminal-container'),
      commandPaletteOverlay: document.querySelector('.command-palette-overlay'),
      titlebar: document.querySelector('.titlebar'),
      titlebarControls: document.querySelector('.titlebar-controls'),
    };
  }

  bindEvents() {
    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => this.handleKeyboard(e));
    
    // Window controls
    this.elements.titlebarControls?.addEventListener('click', (e) => {
      const btn = e.target.closest('[data-action]');
      if (btn) this.handleWindowAction(btn.dataset.action);
    });

    // Double-click title to maximize
    this.elements.titlebar?.querySelector('.titlebar-drag')?.addEventListener('dblclick', () => {
      this.handleWindowAction('maximize');
    });
  }

  handleKeyboard(e) {
    // Command Palette: Ctrl+Shift+P
    if (e.ctrlKey && e.shiftKey && e.key === 'P') {
      e.preventDefault();
      this.toggleCommandPalette();
    }
    
    // Quick Open: Ctrl+P
    if (e.ctrlKey && e.key === 'p' && !e.shiftKey) {
      e.preventDefault();
      this.toggleCommandPalette();
    }
    
    // Toggle Terminal: Ctrl+`
    if (e.ctrlKey && e.key === '`') {
      e.preventDefault();
      this.toggleTerminal();
    }
    
    // Toggle Activity Panel: Ctrl+B
    if (e.ctrlKey && e.key === 'b') {
      e.preventDefault();
      this.toggleActivityPanel();
    }
    
    // Close Command Palette: Escape
    if (e.key === 'Escape' && this.commandPaletteOpen) {
      this.toggleCommandPalette();
    }
  }

  handleWindowAction(action) {
    switch (action) {
      case 'minimize':
        console.log('Window minimize');
        break;
      case 'maximize':
        console.log('Window maximize/restore');
        break;
      case 'close':
        console.log('Window close');
        break;
    }
  }

  // ========================================
  // SIDEBAR NAVIGATION
  // ========================================
  initSidebar() {
    this.elements.sidebarItems.forEach(item => {
      item.addEventListener('click', () => {
        const view = item.dataset.view;
        if (view) this.switchView(view);
      });
    });
  }

  switchView(view) {
    // Update sidebar active state
    this.elements.sidebarItems.forEach(item => {
      item.classList.toggle('active', item.dataset.view === view);
    });
    
    this.activeView = view;
    
    // Update main content based on view
    this.updateMainContent(view);
  }

  updateMainContent(view) {
    const welcomeScreen = this.elements.welcomeScreen;
    if (!welcomeScreen) return;

    // Hide welcome screen when viewing files
    if (view === 'explorer' && this.files.length === 0) {
      welcomeScreen.style.display = 'flex';
    } else {
      welcomeScreen.style.display = 'none';
    }
  }

  // ========================================
  // FILE TABS
  // ========================================
  openFile(file) {
    // Check if file is already open
    let tab = this.findTab(file.path);
    
    if (!tab) {
      // Create new tab
      tab = this.createTab(file);
      this.files.push(file);
    }
    
    this.activeFile = file;
    this.updateActiveTab(tab);
    this.elements.welcomeScreen.style.display = 'none';
  }

  findTab(path) {
    return document.querySelector(`.file-tab[data-path="${CSS.escape(path)}"]`);
  }

  createTab(file) {
    const tab = document.createElement('div');
    tab.className = 'file-tab';
    tab.dataset.path = file.path;
    
    const icon = this.getFileIcon(file.type);
    tab.innerHTML = `
      <span class="file-tab-icon">${icon}</span>
      <span class="file-tab-name">${file.name}</span>
      <span class="file-tab-modified"></span>
      <span class="file-tab-close">
        <svg width="10" height="10" viewBox="0 0 16 16" fill="currentColor">
          <path d="M4.28 3.22a.75.75 0 00-1.06 1.06L6.94 8l-3.72 3.72a.75.75 0 101.06 1.06L8 9.06l3.72 3.72a.75.75 0 101.06-1.06L9.06 8l3.72-3.72a.75.75 0 00-1.06-1.06L8 6.94 4.28 3.22z"/>
        </svg>
      </span>
    `;
    
    tab.addEventListener('click', () => this.selectTab(tab));
    tab.querySelector('.file-tab-close').addEventListener('click', (e) => {
      e.stopPropagation();
      this.closeTab(tab);
    });
    
    this.elements.tabBar.appendChild(tab);
    return tab;
  }

  getFileIcon(type) {
    const icons = {
      js: '<svg viewBox="0 0 16 16" fill="#f1e05a"><path d="M0 0h8v16H0V0zm10 0h6v16h-6V0zM4 2h4v4H4V2zm0 8h4v4H4v-4z"/></svg>',
      ts: '<svg viewBox="0 0 16 16" fill="#3178c6"><path d="M0 0h8v16H0V0zm10 0h6v16h-6V0zM4 2h4v4H4V2zm0 8h4v4H4v-4z"/></svg>',
      html: '<svg viewBox="0 0 16 16" fill="#e34c26"><path d="M1.5 0h13l-1 14.5L8 16l-4.5-1.5L1.5 0z"/><path fill="#fff" d="M4.5 4.5l.7 8h2l-.3 3.5-1.9.6-1.9-.6-.3-3.5h-2l.3 3.5 1.7.5 1.7-.5.3-2H5l-.2-2h5l.2 2h2l-.2-2-.3-3.5h-2l.3 3.5h1.5L11 4.5H4.5z"/></svg>',
      css: '<svg viewBox="0 0 16 16" fill="#563d7c"><path d="M1.5 0h13l-1 14.5L8 16l-4.5-1.5L1.5 0z"/><path fill="#fff" d="M4.5 4.5l.7 8h2l-.3 3.5-1.9.6-1.9-.6-.3-3.5h-2l.3 3.5 1.7.5 1.7-.5.3-2H5l-.2-2h5l.2 2h2l-.2-2-.3-3.5h-2l.3 3.5h1.5L11 4.5H4.5z"/></svg>',
      json: '<svg viewBox="0 0 16 16" fill="#f1e05a"><path d="M5.759 3.975h1.783V5.76H5.759v4.458A1.783 1.783 0 013.975 12a1.783 1.783 0 011.784-1.783v1.783h1.783v-1.783a1.783 1.783 0 011.783-1.783 1.783 1.783 0 011.784 1.783 1.783 1.783 0 01-1.784 1.782V14.8H7.542v1.783h1.784v-1.783a1.783 1.783 0 011.783-1.783 1.783 1.783 0 011.784 1.783 1.783 1.783 0 01-1.784 1.782v-1.783h-1.783v1.783A1.783 1.783 0 017.543 15a1.783 1.783 0 01-1.784-1.783V8.759H3.975v4.458A1.783 1.783 0 012.192 14 1.783 1.783 0 01.409 12a1.783 1.783 0 011.783-1.783V8.542H.409V10.32h1.783v-1.783A1.783 1.783 0 01.409 5a1.783 1.783 0 011.783 1.783v1.783h1.784V6.783A1.783 1.783 0 015.759 5a1.783 1.783 0 01-1.784 1.783v1.783h1.784v-1.783A1.783 1.783 0 017.542 5a1.783 1.783 0 011.784 1.783v4.459H7.542V6.783A1.783 1.783 0 015.759 5a1.783 1.783 0 01-.001-1.025z"/></svg>',
      md: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M14.85 3H1.15C.52 3 0 3.52 0 4.15v7.69C0 12.48.52 13 1.15 13h13.69c.64 0 1.15-.52 1.15-1.15V4.15C16 3.52 15.48 3 14.85 3zM9 11H7V8H5l3-4 3 4H9v3z"/></svg>',
      default: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M4 1.5H3a2 2 0 00-2 2V14a2 2 0 002 2h10a2 2 0 002-2V3.5a2 2 0 00-2-2h-1v1h1a1 1 0 011 1V14a1 1 0 01-1 1H3a1 1 0 01-1-1V3.5a1 1 0 011-1h1v-1z"/><path d="M9.5 1a.5.5 0 01.5.5v1a.5.5 0 01-.5.5h-3a.5.5 0 01-.5-.5v-1a.5.5 0 01.5-.5h3zm-3-1A1.5 1.5 0 005 1.5v1A1.5 1.5 0 006.5 4h3A1.5 1.5 0 0011 2.5v-1A1.5 1.5 0 009.5 0h-3z"/></svg>'
    };
    return icons[type] || icons.default;
  }

  selectTab(tab) {
    this.updateActiveTab(tab);
    const path = tab.dataset.path;
    const file = this.files.find(f => f.path === path);
    if (file) this.activeFile = file;
  }

  updateActiveTab(activeTab) {
    document.querySelectorAll('.file-tab').forEach(tab => {
      tab.classList.toggle('active', tab === activeTab);
    });
  }

  closeTab(tab) {
    const wasActive = tab.classList.contains('active');
    const path = tab.dataset.path;
    
    tab.remove();
    this.files = this.files.filter(f => f.path !== path);
    
    // If closed tab was active, select another
    if (wasActive) {
      const nextTab = document.querySelector('.file-tab:last-child');
      if (nextTab) {
        this.selectTab(nextTab);
      } else {
        this.activeFile = null;
        if (this.files.length === 0) {
          this.elements.welcomeScreen.style.display = 'flex';
        }
      }
    }
  }

  // ========================================
  // COMMAND PALETTE
  // ========================================
  initCommandPalette() {
    if (!this.elements.commandPaletteOverlay) return;
    
    this.commandPalette = new CommandPalette({
      container: this.elements.commandPaletteOverlay,
      onSelect: (item) => this.handleCommandSelect(item)
    });
  }

  toggleCommandPalette() {
    this.commandPaletteOpen = !this.commandPaletteOpen;
    this.elements.commandPaletteOverlay?.classList.toggle('open', this.commandPaletteOpen);
    
    if (this.commandPaletteOpen) {
      this.commandPalette.focus();
    }
  }

  handleCommandSelect(item) {
    this.toggleCommandPalette();
    
    switch (item.id) {
      case 'new-file':
        console.log('Create new file');
        break;
      case 'open-folder':
        console.log('Open folder');
        break;
      case 'save':
        console.log('Save file');
        break;
      case 'toggle-terminal':
        this.toggleTerminal();
        break;
      case 'toggle-sidebar':
        this.toggleSidebar();
        break;
      case 'toggle-activity':
        this.toggleActivityPanel();
        break;
      case 'settings':
        console.log('Open settings');
        break;
    }
  }

  // ========================================
  // TERMINAL
  // ========================================
  initTerminal() {
    if (!this.elements.terminal) return;
    
    this.terminal = new Terminal({
      container: this.elements.terminal
    });
  }

  toggleTerminal() {
    if (!this.elements.terminal) return;
    
    const isHidden = this.elements.terminal.style.display === 'none';
    this.elements.terminal.style.display = isHidden ? 'flex' : 'none';
  }

  // ========================================
  // ACTIVITY PANEL
  // ========================================
  initActivityPanel() {
    if (!this.elements.activityPanel) return;
    
    this.activityPanel = new ActivityPanel({
      container: this.elements.activityPanel
    });
  }

  toggleActivityPanel() {
    if (!this.elements.activityPanel) return;
    
    this.isActivityPanelOpen = !this.isActivityPanelOpen;
    this.elements.activityPanel.style.display = this.isActivityPanelOpen ? 'flex' : 'none';
    this.elements.app.classList.toggle('with-activity', this.isActivityPanelOpen);
  }

  // ========================================
  // WINDOW CONTROLS
  // ========================================
  initWindowControls() {
    const controls = this.elements.titlebarControls;
    if (!controls) return;

    // Add hover effects via CSS
    controls.addEventListener('mouseenter', (e) => {
      const btn = e.target.closest('.titlebar-btn');
      if (btn) btn.style.background = 'var(--bg-elevated)';
    });

    controls.addEventListener('mouseleave', (e) => {
      const btn = e.target.closest('.titlebar-btn');
      if (btn && !btn.matches('.titlebar-btn-close:hover')) {
        btn.style.background = '';
      }
    });
  }

  // ========================================
  // TOAST NOTIFICATIONS
  // ========================================
  showToast(message, type = 'info') {
    const container = document.querySelector('.toast-container') || this.createToastContainer();
    
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
      <span class="toast-icon">${this.getToastIcon(type)}</span>
      <span class="toast-message">${message}</span>
      <button class="toast-close">
        <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
          <path d="M4.28 3.22a.75.75 0 00-1.06 1.06L6.94 8l-3.72 3.72a.75.75 0 101.06 1.06L8 9.06l3.72 3.72a.75.75 0 101.06-1.06L9.06 8l3.72-3.72a.75.75 0 00-1.06-1.06L8 6.94 4.28 3.22z"/>
        </svg>
      </button>
    `;
    
    toast.querySelector('.toast-close').addEventListener('click', () => {
      toast.remove();
    });
    
    container.appendChild(toast);
    
    setTimeout(() => {
      toast.remove();
    }, 5000);
  }

  createToastContainer() {
    const container = document.createElement('div');
    container.className = 'toast-container';
    document.body.appendChild(container);
    return container;
  }

  getToastIcon(type) {
    const icons = {
      success: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z"/></svg>',
      warning: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8.22 1.754a.25.25 0 00-.44 0L1.698 13.132a.25.25 0 00.22.368h12.164a.25.25 0 00.22-.368L8.22 1.754zm-1.763-.707c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0114.082 15H1.918a1.75 1.75 0 01-1.543-2.575L6.457 1.047zM9 11a1 1 0 11-2 0 1 1 0 012 0zm-.25-5.25a.75.75 0 00-1.5 0v2.5a.75.75 0 001.5 0v-2.5z"/></svg>',
      error: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M3.72 3.72a.75.75 0 011.06 0L8 6.94l3.22-3.22a.75.75 0 111.06 1.06L9.06 8l3.22 3.22a.75.75 0 11-1.06 1.06L8 9.06l-3.22 3.22a.75.75 0 01-1.06-1.06L6.94 8 3.72 4.78a.75.75 0 010-1.06z"/></svg>',
      info: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M0 8a8 8 0 1116 0A8 8 0 010 8zm8-6.5a6.5 6.5 0 100 13 6.5 6.5 0 000-13zM6.92 6.085h.008v3.312h-.008V6.085zM6.27 11.864h.008v.479h-.008v-.479zm.004-2.484h.008v1.34h-.008V9.38zm.004 4.638h.008v.479h-.008v-.479zm.004-2.484h.008v1.34h-.008V9.38zm1.537-2.154h.956v.479h-.956v-.479zm0 .959h.956v.479h-.956V9.38zm0 2.524h.956v.479h-.956v-.479zm0 2.114h.956v.479h-.956v-.479z"/></svg>'
    };
    return icons[type] || icons.info;
  }
}

// Initialize app when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  window.linkUpStudio = new LinkUpStudio();
});