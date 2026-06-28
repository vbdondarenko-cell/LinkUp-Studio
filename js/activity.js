/**
 * LinkUp Studio - Activity Panel
 * Linear-inspired activity and issue tracking
 */

class ActivityPanel {
  constructor(options) {
    this.container = options.container;
    this.activeTab = 'issues';
    this.issues = this.getMockIssues();
    this.activity = this.getMockActivity();
    
    this.init();
  }

  getMockIssues() {
    return [
      {
        id: 'ALL-234',
        title: 'Improve sidebar animation performance',
        description: 'Reduce jank when expanding sidebar items',
        priority: 1,
        status: 'in_progress',
        assignee: 'vbdondarenko',
        updatedAt: '2 hours ago'
      },
      {
        id: 'ALL-233',
        title: 'Add keyboard shortcuts for terminal',
        description: 'Implement Ctrl+C, Ctrl+L and other terminal shortcuts',
        priority: 2,
        status: 'todo',
        assignee: 'vbdondarenko',
        updatedAt: '4 hours ago'
      },
      {
        id: 'ALL-232',
        title: 'Fix command palette positioning',
        description: 'Center palette vertically and add animation',
        priority: 3,
        status: 'done',
        assignee: 'vbdondarenko',
        updatedAt: '1 day ago'
      },
      {
        id: 'ALL-231',
        title: 'Implement dark mode toggle',
        description: 'Add theme switcher in settings',
        priority: 4,
        status: 'backlog',
        assignee: 'vbdondarenko',
        updatedAt: '2 days ago'
      },
      {
        id: 'ALL-230',
        title: 'Add GitHub integration',
        description: 'Connect to GitHub API for PR reviews',
        priority: 2,
        status: 'in_progress',
        assignee: 'vbdondarenko',
        updatedAt: '3 days ago'
      }
    ];
  }

  getMockActivity() {
    return [
      {
        type: 'commit',
        title: 'pushed to main',
        description: 'Add terminal component with Warp styling',
        time: '10 minutes ago',
        icon: 'commit'
      },
      {
        type: 'pr',
        title: 'Opened PR #42',
        description: 'feat: Add command palette with Raycast design',
        time: '1 hour ago',
        icon: 'pr'
      },
      {
        type: 'issue',
        title: 'Closed ALL-229',
        description: 'Implement activity panel design',
        time: '3 hours ago',
        icon: 'issue'
      },
      {
        type: 'comment',
        title: 'Commented on ALL-234',
        description: 'Working on the animation optimization',
        time: '5 hours ago',
        icon: 'comment'
      },
      {
        type: 'deploy',
        title: 'Deployed to production',
        description: 'v1.0.0 - Initial release',
        time: '1 day ago',
        icon: 'deploy'
      }
    ];
  }

  init() {
    this.render();
    this.bindEvents();
  }

  render() {
    this.container.innerHTML = `
      <div class="activity-header">
        <span class="activity-title">Activity</span>
        <button class="btn-icon btn-ghost btn-sm" id="activity-settings">
          <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
            <path d="M8 4.754a3.246 3.246 0 100 6.492 3.246 3.246 0 000-6.492zM5.754 8a2.246 2.246 0 114.492 0 2.246 2.246 0 01-4.492 0z"/>
            <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 01-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 01-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 01.52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 011.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 011.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 01.52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 01-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 01-1.255-.52l-.094-.319z"/>
          </svg>
        </button>
      </div>
      <div class="activity-tabs">
        <div class="activity-tab ${this.activeTab === 'issues' ? 'active' : ''}" data-tab="issues">
          Issues
        </div>
        <div class="activity-tab ${this.activeTab === 'activity' ? 'active' : ''}" data-tab="activity">
          Activity
        </div>
        <div class="activity-tab ${this.activeTab === 'notifications' ? 'active' : ''}" data-tab="notifications">
          Notifications
        </div>
      </div>
      <div class="activity-content" id="activity-content">
        ${this.renderContent()}
      </div>
    `;
  }

  renderContent() {
    switch (this.activeTab) {
      case 'issues':
        return this.renderIssues();
      case 'activity':
        return this.renderActivity();
      case 'notifications':
        return this.renderNotifications();
      default:
        return '';
    }
  }

  renderIssues() {
    const statusLabels = {
      backlog: 'Backlog',
      todo: 'Todo',
      in_progress: 'In Progress',
      done: 'Done',
      canceled: 'Canceled'
    };

    const statusClasses = {
      backlog: 'issue-status-backlog',
      todo: 'issue-status-todo',
      in_progress: 'issue-status-in-progress',
      done: 'issue-status-done',
      canceled: 'issue-status-canceled'
    };

    return `
      <div class="activity-section">
        <div class="activity-section-title">
          <span>My Issues</span>
          <button class="btn-icon btn-ghost btn-sm">
            <svg width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
              <path d="M8 4a.5.5 0 01.5.5v3h3a.5.5 0 010 1h-3v3a.5.5 0 01-1 0v-3h-3a.5.5 0 010-1h3v-3A.5.5 0 018 4z"/>
            </svg>
          </button>
        </div>
        ${this.issues.map(issue => `
          <div class="issue-card" data-issue="${issue.id}">
            <div class="issue-card-header">
              <span class="issue-priority issue-priority-${this.getPriorityClass(issue.priority)}"></span>
              <span class="issue-identifier">${issue.id}</span>
            </div>
            <div class="issue-title">${issue.title}</div>
            <div class="issue-description">${issue.description}</div>
            <div class="issue-meta">
              <span class="issue-status ${statusClasses[issue.status]}">
                <span class="issue-status-dot"></span>
                ${statusLabels[issue.status]}
              </span>
              <span class="issue-assignee">@${issue.assignee}</span>
            </div>
          </div>
        `).join('')}
      </div>
    `;
  }

  renderActivity() {
    const iconMap = {
      commit: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M10.5 7.75a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0zm1.43.75a4.002 4.002 0 01-7.86 0H.75a.75.75 0 110-1.5h3.32a4.001 4.001 0 017.86 0h3.32a.75.75 0 110 1.5h-3.32z"/></svg>',
      pr: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M3 2.5a.5.5 0 01.5-.5h5a.5.5 0 010 1h-5a.5.5 0 01-.5-.5zm0 2a.5.5 0 01.5-.5h7a.5.5 0 010 1h-7a.5.5 0 01-.5-.5zm0 2a.5.5 0 01.5-.5h9a.5.5 0 010 1h-9a.5.5 0 01-.5-.5zm0 2a.5.5 0 01.5-.5h2a.5.5 0 010 1h-2a.5.5 0 01-.5-.5z"/></svg>',
      issue: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8 9.5a1.5 1.5 0 100-3 1.5 1.5 0 000 3z"/><path d="M8 0a8 8 0 100 16A8 8 0 008 0zM1.5 8a6.5 6.5 0 1113 0 6.5 6.5 0 01-13 0z"/></svg>',
      comment: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M2.5 3.5a.5.5 0 01.5-.5h10a.5.5 0 010 1h-10a.5.5 0 01-.5-.5zm0 3a.5.5 0 01.5-.5h10a.5.5 0 010 1h-10a.5.5 0 01-.5-.5zm0 3a.5.5 0 01.5-.5h6a.5.5 0 010 1h-6a.5.5 0 01-.5-.5z"/></svg>',
      deploy: '<svg viewBox="0 0 16 16" fill="currentColor"><path d="M8.906 3.95a.75.75 0 01-.188.918L6.643 6.51l-2.175 1.646a.75.75 0 01-1.045-1.035l2.97-2.25a.75.75 0 011.106.067l3.408 2.575a.75.75 0 010 1.175l-3.408 2.575a.75.75 0 01-1.106-.067L5.25 8.373 3.406 7.73a.75.75 0 011.045-1.035l2.175 1.646 2.076-1.645a.75.75 0 01.918-.188l.012-.012z"/></svg>'
    };

    return `
      <div class="activity-section">
        <div class="activity-section-title">
          <span>Recent Activity</span>
        </div>
        ${this.activity.map(item => `
          <div class="activity-item">
            <div class="activity-item-icon">
              ${iconMap[item.icon]}
            </div>
            <div class="activity-item-content">
              <div class="activity-item-title">${item.title}</div>
              <div class="activity-item-meta">
                <span>${item.description}</span>
                <span>•</span>
                <span>${item.time}</span>
              </div>
            </div>
          </div>
        `).join('')}
      </div>
    `;
  }

  renderNotifications() {
    return `
      <div class="activity-section">
        <div class="activity-section-title">
          <span>Notifications</span>
          <button class="btn-ghost btn-sm">Mark all read</button>
        </div>
        <div class="empty-state">
          <div class="empty-state-icon">
            <svg viewBox="0 0 16 16" fill="currentColor">
              <path d="M8 16a2 2 0 001.985-1.75c.017-.137-.097-.25-.235-.25h-3.5c-.138 0-.252.113-.235.25A2 2 0 008 16zM3 5a5 5 0 0110 0v2.947c0 .05.015.098.042.139l1.703 2.555A1.518 1.518 0 0113.482 13H2.518a1.518 1.518 0 01-1.263-2.36l1.703-2.554A.255.255 0 003 7.947V5z"/>
            </svg>
          </div>
          <div class="empty-state-title">No new notifications</div>
          <div class="empty-state-description">You're all caught up!</div>
        </div>
      </div>
    `;
  }

  getPriorityClass(priority) {
    const classes = {
      0: 'none',
      1: 'urgent',
      2: 'high',
      3: 'medium',
      4: 'low'
    };
    return classes[priority] || 'none';
  }

  bindEvents() {
    // Tab switching
    this.container.querySelectorAll('.activity-tab').forEach(tab => {
      tab.addEventListener('click', () => {
        this.activeTab = tab.dataset.tab;
        this.container.querySelectorAll('.activity-tab').forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        document.getElementById('activity-content').innerHTML = this.renderContent();
      });
    });

    // Issue card clicks
    this.container.addEventListener('click', (e) => {
      const issueCard = e.target.closest('.issue-card');
      if (issueCard) {
        const issueId = issueCard.dataset.issue;
        this.handleIssueClick(issueId);
      }
    });
  }

  handleIssueClick(issueId) {
    console.log('Opening issue:', issueId);
    // In a real implementation, this would open the issue details
  }

  updateIssues(issues) {
    this.issues = issues;
    if (this.activeTab === 'issues') {
      document.getElementById('activity-content').innerHTML = this.renderIssues();
    }
  }

  addActivity(activity) {
    this.activity.unshift(activity);
    if (this.activeTab === 'activity') {
      document.getElementById('activity-content').innerHTML = this.renderActivity();
    }
  }
}