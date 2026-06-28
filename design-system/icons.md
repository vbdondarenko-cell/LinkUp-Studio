# LinkUp Studio Icon System

## Overview

LinkUp Studio uses a minimal, GitHub-inspired icon system with consistent visual language.

## Design Principles

1. **Minimal** - Only essential elements, no decorative details
2. **Consistent** - Same stroke width, rounded corners, visual weight
3. **Readable** - Clear at 16x16px, scalable to any size
4. **Purposeful** - Each icon has one clear meaning

## Technical Specifications

### Grid System
- Base grid: 16x16px for UI icons
- Larger icons: 24x24px, 32x32px
- Use even numbers for clean pixel alignment

### Stroke Style
- Stroke width: 1.5px for standard icons
- Stroke linecap: `round`
- Stroke linejoin: `round`
- Fill: `currentColor` (inherits from parent)

### Corner Radius
- Sharp corners: 0px for minimal icons
- Rounded corners: 2px for standard icons
- Fully rounded: 4px for circular elements

### Spacing
- Icon padding: 1px minimum from edges
- Optical center alignment
- Consistent visual weight

## Color Usage

```css
/* Default state */
.icon {
  color: var(--text-secondary);
}

/* Hover state */
.icon:hover {
  color: var(--text-primary);
}

/* Active state */
.icon.active {
  color: var(--accent-fg);
}

/* Disabled state */
.icon:disabled {
  color: var(--text-disabled);
}
```

## Icon Categories

### Navigation Icons
Used in sidebar and main navigation.

| Icon | Usage | Example |
|------|-------|---------|
| Explorer | File browser | sidebar, activity |
| Search | Global search | Ctrl+Shift+F |
| Git | Source control | Git operations |
| Debug | Debugging tools | Run and debug |
| Extensions | Extension panel | VS Code extensions |
| Settings | Application settings | Preferences |
| Command | Command palette | Ctrl+Shift+P |

### Action Icons
Used for interactive elements.

| Icon | Usage | Example |
|------|-------|---------|
| Plus | Add/create | New file, new tab |
| Minus | Remove/delete | Delete item |
| Close | Close/dismiss | Close tab, close modal |
| Check | Confirm/select | Checkbox, success state |
| Copy | Duplicate | Copy to clipboard |
| Edit | Modify | Edit text, rename |
| Trash | Delete | Remove permanently |
| Download | Export | Download file |
| Upload | Import | Upload file |
| Refresh | Reload | Refresh content |
| Expand | Show more | Expand section |
| Collapse | Show less | Collapse section |
| External | Open external | Open link |
| Star | Favorite | Mark as favorite |
| Bell | Notification | Alert indicator |

### Status Icons
Used to indicate state or status.

| Icon | Usage | Status |
|------|-------|--------|
| ✓ Check | Success | Completed |
| ! Alert | Warning | Attention needed |
| × Error | Danger | Error occurred |
| ⓘ Info | Info | Information |
| ○ Pending | Neutral | Waiting |
| ◐ Loading | Progress | In progress |

### File Type Icons
Used in file explorer and tabs.

| Icon | Usage |
|------|-------|
| File | Generic file |
| Folder | Folder |
| Folder Open | Expanded folder |
| JS | JavaScript file |
| TS | TypeScript file |
| JSON | JSON file |
| MD | Markdown file |
| HTML | HTML file |
| CSS | Stylesheet |
| Git | Git-related |

## Icon Usage in CSS

### Inline SVG (Recommended)
```html
<svg viewBox="0 0 16 16" fill="currentColor" class="icon">
  <path d="M..."/>
</svg>
```

### As a Component
```jsx
<Icon name="search" size={16} className="icon" />
```

### CSS Background Image
```css
.icon-search {
  background-image: url("data:image/svg+xml,...");
  background-size: contain;
  background-repeat: no-repeat;
}
```

## Accessibility

### ARIA Labels
All icons used as interactive elements must have accessible labels.

```html
<!-- Icon only -->
<button aria-label="Close tab">
  <svg aria-hidden="true" viewBox="0 0 16 16">
    <path d="M..."/>
  </svg>
</button>

<!-- Icon with text -->
<button>
  <svg aria-hidden="true" viewBox="0 0 16 16">
    <path d="M..."/>
  </svg>
  <span>Close</span>
</button>
```

### Focus States
Icons should maintain visibility in focus states.

```css
button:focus-visible .icon {
  outline: 2px solid var(--accent-fg);
  outline-offset: 2px;
}
```

## Common Icons Reference

### Sidebar Icons (16x16)

```html
<!-- Explorer -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M1 3.5A1.5 1.5 0 012.5 2h2.764c.958 0 1.76.56 2.311 1.184C7.985 3.648 8.48 4 9 4h4.5A1.5 1.5 0 0115 5.5v.64c.57.265.94.876.856 1.546l-.64 5.124A2.5 2.5 0 0112.733 15H3.266a2.5 2.5 0 01-2.481-2.19l-.64-5.124A1.5 1.5 0 011 3.5V3.5z"/>
</svg>

<!-- Search -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M10.68 11.74a6 6 0 01-7.922-8.982 6 6 0 118.982 7.922l3.04 3.04a.749.749 0 101.06-1.06l-3.04-3.04zM11.5 7a4.499 4.499 0 11-8.997 0A4.499 4.499 0 0111.5 7z"/>
</svg>

<!-- Git Branch -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M11.75 2.5a.75.75 0 100 1.5.75.75 0 000-1.5zm-2.25.75a2.25 2.25 0 113 2.122V6A2.5 2.5 0 0110 8.5H6a1 1 0 00-1 1v1.128a2.251 2.251 0 11-1.5 0V5.372a2.25 2.25 0 111.5 0v1.836A2.492 2.492 0 016 7h4a1 1 0 001-1v-.628A2.25 2.25 0 019.5 3.25z"/>
</svg>

<!-- Settings -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M8 4.754a3.246 3.246 0 100 6.492 3.246 3.246 0 000-6.492zM5.754 8a2.246 2.246 0 114.492 0 2.246 2.246 0 01-4.492 0z"/>
  <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 01-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 01-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 01.52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 011.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 011.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 01.52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 01-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 01-1.255-.52l-.094-.319z"/>
</svg>

<!-- Command Palette -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M10.478 1.647a.5.5 0 10-.956-.294l-4 13a.5.5 0 00.956.294l4-13zM4.854 4.146a.5.5 0 01.708 0l3 3a.5.5 0 010 .708l-3 3a.5.5 0 01-.708-.708L7.69 8 4.146 4.854a.5.5 0 010-.708z"/>
</svg>
```

### Action Icons (16x16)

```html
<!-- Plus -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M8 4a.5.5 0 01.5.5v3h3a.5.5 0 010 1h-3v3a.5.5 0 01-1 0v-3h-3a.5.5 0 010-1h3v-3A.5.5 0 018 4z"/>
</svg>

<!-- Close -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M4.28 3.22a.75.75 0 00-1.06 1.06L6.94 8l-3.72 3.72a.75.75 0 101.06 1.06L8 9.06l3.72 3.72a.75.75 0 101.06-1.06L9.06 8l3.72-3.72a.75.75 0 00-1.06-1.06L8 6.94 4.28 3.22z"/>
</svg>

<!-- Check -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M13.78 4.22a.75.75 0 010 1.06l-7.25 7.25a.75.75 0 01-1.06 0L2.22 9.28a.75.75 0 011.06-1.06L6 10.94l6.72-6.72a.75.75 0 011.06 0z"/>
</svg>

<!-- Copy -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M0 6.75C0 5.784.784 5 1.75 5h1.5a.75.75 0 010 1.5h-1.5a.25.25 0 00-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 00.25-.25v-1.5a.75.75 0 011.5 0v1.5A1.75 1.75 0 019.25 16h-7.5A1.75 1.75 0 010 14.25v-7.5z"/>
  <path d="M5 1.75C5 .784 5.784 0 6.75 0h7.5C15.216 0 16 .784 16 1.75v7.5A1.75 1.75 0 0114.25 11h-7.5A1.75 1.75 0 015 9.25v-7.5zm1.75-.25a.25.25 0 00-.25.25v7.5c0 .138.112.25.25.25h7.5a.25.25 0 00.25-.25v-7.5a.25.25 0 00-.25-.25h-7.5z"/>
</svg>

<!-- Chevron Down -->
<svg viewBox="0 0 16 16" fill="currentColor">
  <path d="M12.78 5.22a.749.749 0 010 1.06l-4.25 4.25a.749.749 0 01-1.06 0L3.22 6.28a.749.749 0 111.06-1.06L8 8.94l3.72-3.72a.749.749 0 011.06 0z"/>
</svg>
```

## Icon Sizing

| Size | CSS Class | Usage |
|------|----------|-------|
| 12px | `.icon-xs` | Inline with text, small labels |
| 14px | `.icon-sm` | Standard sidebar icons |
| 16px | `.icon` | Default icon size |
| 20px | `.icon-md` | Toolbar icons |
| 24px | `.icon-lg` | Feature icons |
| 32px | `.icon-xl` | Empty state icons |
| 48px | `.icon-2xl` | Hero icons |

## Best Practices

1. **Use SVG inline** for better control and accessibility
2. **Prefer `currentColor`** for flexible color inheritance
3. **Set consistent viewBox** (16x16) for standard icons
4. **Provide ARIA labels** on all interactive icons
5. **Use semantic names** (close, not x)
6. **Maintain visual weight** across all icons
7. **Test at all sizes** from 12px to 32px
