# LinkUp Studio - Specification Document

## 1. Concept & Vision

LinkUp Studio is a premium Windows 10 developer environment that embodies the intersection of modern design philosophy from GitHub, Linear, Raycast, Arc Browser, Warp Terminal, and Apple Human Interface Guidelines. It is a cohesive visual workspace where every pixel serves a purpose, every interaction feels intentional, and the entire ecosystem speaks in one unified design language.

**Core Philosophy:** Darkness with purpose. No bright colors. No visual noise. Just pure, refined functionality that respects the developer's focus and time.

**Personality:** Professional. Minimal. Precise. Like a well-organized workshop where every tool has its place.

---

## 2. Design Language

### Aesthetic Direction
**Reference:** GitHub Dark theme meets Linear's spatial elegance and Arc Browser's innovative navigation.

The aesthetic is "professional darkness" — deep blacks with subtle purple undertones, sharp but not harsh borders, and strategic use of accent colors only where attention is needed.

### Color Palette

```css
:root {
  /* Base Backgrounds - Layered Depth */
  --bg-canvas: #0d1117;        /* Deepest layer - main canvas */
  --bg-surface: #161b22;       /* Elevated surfaces - cards, panels */
  --bg-elevated: #21262d;      /* Highest elevation - modals, dropdowns */
  --bg-overlay: #30363d;       /* Overlays - tooltips, hover states */
  
  /* Borders & Dividers */
  --border-default: #30363d;   /* Standard borders */
  --border-muted: #21262d;     /* Subtle dividers */
  --border-accent: #388bfd40;  /* Focus rings, active states */
  
  /* Text Colors - Hierarchy */
  --text-primary: #e6edf3;     /* Primary content */
  --text-secondary: #8b949e;   /* Secondary, labels */
  --text-tertiary: #6e7681;    /* Disabled, hints */
  --text-inverse: #0d1117;     /* Text on accent */
  
  /* Accent Colors - GitHub Blue Family */
  --accent-fg: #58a6ff;        /* Primary accent */
  --accent-emphasis: #1f6feb;  /* Emphasis, buttons */
  --accent-muted: #388bfd26;   /* Backgrounds with accent */
  
  /* Semantic Colors */
  --success-fg: #3fb950;       /* Success states */
  --success-muted: #238636;    /* Success backgrounds */
  --warning-fg: #d29922;       /* Warning states */
  --warning-muted: #9e6a03;    /* Warning backgrounds */
  --danger-fg: #f85149;        /* Danger, errors */
  --danger-muted: #da3633;     /* Danger backgrounds */
  
  /* Special Colors */
  --purple-accent: #a371f7;    /* Links, special actions */
  --orange-accent: #f0883e;    /* Notifications, alerts */
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.3);
  --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.4);
  --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.5);
  --shadow-glow: 0 0 20px rgba(56, 139, 253, 0.15);
}
```

### Typography

**Font Stack:**
```css
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', 'Cascadia Code', Consolas, monospace;
```

**Type Scale (based on 14px base):**
```css
--text-xs: 11px;    /* 0.786rem - timestamps, badges */
--text-sm: 12px;    /* 0.857rem - secondary labels */
--text-base: 14px;  /* 1rem - body text */
--text-lg: 16px;    /* 1.143rem - section headers */
--text-xl: 20px;    /* 1.429rem - panel titles */
--text-2xl: 24px;   /* 1.714rem - main headings */
```

**Line Heights:**
- Headings: 1.25
- Body: 1.5
- Code: 1.6

### Spacing System

Based on 4px grid:
```css
--space-1: 4px;
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-5: 20px;
--space-6: 24px;
--space-8: 32px;
--space-10: 40px;
--space-12: 48px;
```

**Border Radius:**
```css
--radius-sm: 4px;
--radius-md: 6px;
--radius-lg: 8px;
--radius-xl: 12px;
--radius-full: 9999px;
```

### Motion Philosophy

**Principles:** 
- Purposeful - every animation communicates state change
- Swift - quick response (150-300ms) respects developer time
- Subtle - motion should be felt, not seen

**Timing Functions:**
```css
--ease-out: cubic-bezier(0.16, 1, 0.3, 1);     /* Natural deceleration */
--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1); /* Balanced transitions */
--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1); /* Bouncy, for emphasis */
```

**Durations:**
```css
--duration-instant: 50ms;   /* Hover states */
--duration-fast: 150ms;     /* Small transitions */
--duration-normal: 250ms;   /* Panel transitions */
--duration-slow: 400ms;     /* Major state changes */
```

---

## 3. Layout & Structure

### Overall Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│  Custom Title Bar (drag region, window controls)                    │
├────────────┬────────────────────────────────────────┬───────────────┤
│            │                                        │               │
│  Sidebar   │         Main Content Area              │   Activity    │
│  (56px)    │         (flexible)                     │   Panel       │
│            │                                        │   (320px)     │
│  - Logo    │  ┌──────────────────────────────────┐  │               │
│  - Nav     │  │  Tab Bar (file tabs)             │  │  - Issues     │
│  - Quick   │  ├──────────────────────────────────┤  │  - Activity   │
│    Actions │  │                                  │  │  - Search     │
│            │  │  Editor / Workspace              │  │               │
│            │  │                                  │  │               │
│            │  │                                  │  │               │
│            │  └──────────────────────────────────┘  │               │
│            │                                        │               │
│            │  ┌──────────────────────────────────┐  │               │
│            │  │  Terminal (Warp-inspired)        │  │               │
│            │  └──────────────────────────────────┘  │               │
├────────────┴────────────────────────────────────────┴───────────────┤
│  Status Bar (git branch, language, problems)                        │
└─────────────────────────────────────────────────────────────────────┘
```

### Component Pacing

1. **Title Bar** - Minimal, functional, 32px height
2. **Sidebar** - Compact icon navigation, 56px width, expandable to 240px
3. **Main Area** - Maximum space for content
4. **Activity Panel** - Collapsible right panel for context
5. **Status Bar** - Information density, 24px height

### Responsive Strategy
- Minimum viewport: 1024x768
- Sidebar collapses to icons below 1280px
- Activity panel hides below 1440px (toggle available)

---

## 4. Features & Interactions

### 4.1 Custom Title Bar
- Draggable region for window movement
- Window controls: minimize (—), maximize (□/⧉), close (×)
- App title centered or left-aligned
- Git branch indicator

**Interactions:**
- Hover on controls: subtle bg color change
- Close button hover: red background (#f85149)
- Double-click title: toggle maximize

### 4.2 Sidebar Navigation (Arc Browser inspired)

**Structure:**
```
┌──────┐
│ Logo │  ← LinkUp Studio icon
├──────┤
│ 📁   │  ← Explorer (file tree)
│ 🔍   │  ← Search (global search)
│ 🧭   │  ← Git (source control)
│ 🐛   │  ← Issues (Linear-inspired)
│ ⚙️   │  ← Extensions
├──────┤
│      │  ← Collapsible section
│ 📌   │  ← Pinned files
│ 📂   │  ← Recent files
├──────┤
│ ⚡   │  ← Command Palette (Raycast-style)
└──────┘
```

**Interactions:**
- Hover: bg changes to --bg-elevated
- Active: left border accent + bg-muted
- Tooltip on hover (after 500ms delay)
- Section collapse with smooth animation

### 4.3 Command Palette (Raycast-inspired)

**Trigger:** Ctrl+Shift+P or click lightning bolt

**Design:**
- Centered modal, 600px width
- Search input with keyboard icon
- Results list with keyboard shortcuts
- Categories: Commands, Files, Issues, Actions

**Interactions:**
- Type to filter instantly
- Arrow keys to navigate
- Enter to execute
- Escape to close
- Recent commands shown first

### 4.4 Activity Panel (Linear-inspired)

**Sections:**
1. **My Issues** - Assigned issues with status indicators
2. **Recent Activity** - Git commits, file changes
3. **Notifications** - GitHub-style notifications

**Issue Card Design:**
```
┌────────────────────────────────────┐
│ ● ALL-234  Improve sidebar         │
│         performance                │
│ ○ In Progress • vbdondarenko      │
└────────────────────────────────────┘
```

**Interactions:**
- Click to expand/collapse
- Hover: subtle elevation increase
- Priority indicators: colored dots

### 4.5 Terminal (Warp Terminal-inspired)

**Design Elements:**
- Blurred backdrop effect
- Custom prompt styling
- Smooth cursor
- Command grouping
- Output with syntax highlighting

**Interactions:**
- Click to focus
- Scroll with preserved output
- Tab completion visual feedback
- Copy on selection

### 4.6 Tab Bar

**Design:**
- Horizontal scrollable tabs
- Active tab highlighted
- Close button on hover
- File type icons
- Modified indicator (dot)

**Interactions:**
- Drag to reorder
- Middle-click to close
- Double-click to rename
- Right-click for context menu

### 4.7 Status Bar

**Content:**
- Git branch + status (ahead/behind)
- Current language
- Line/column position
- Encoding
- Problems count
- GitHub connection status

---

## 5. Component Inventory

### 5.1 Buttons

**Primary Button**
- Default: --accent-emphasis bg, white text
- Hover: 10% lighter bg
- Active: 10% darker bg
- Disabled: 50% opacity, no pointer events
- Focus: 2px ring with --border-accent

**Secondary Button**
- Default: transparent bg, --text-secondary
- Hover: --bg-elevated bg
- Border: 1px --border-default

**Ghost Button**
- No border, transparent bg
- Hover: subtle bg
- Icon buttons: 32x32px, rounded

**Danger Button**
- --danger-muted bg
- Hover: --danger-fg text

### 5.2 Input Fields

**Text Input**
- Default: --bg-surface bg, --border-default border
- Focus: --border-accent border, subtle glow
- Error: --danger-fg border
- Disabled: 50% opacity

**Search Input**
- Magnifying glass icon prefix
- Clear button on content
- Keyboard shortcut hint suffix

### 5.3 Cards

**Base Card**
- --bg-surface bg
- --radius-lg border-radius
- 1px --border-muted border
- --shadow-sm shadow
- Hover: --shadow-md, slight translate-y

**Issue Card**
- Priority indicator (colored dot)
- Title, description preview
- Metadata row (status, assignee)

### 5.4 Dropdowns

**Dropdown Menu**
- --bg-elevated bg
- --shadow-lg shadow
- --radius-md border-radius
- Dividers between sections
- Keyboard navigation

### 5.5 Tooltips

- --bg-elevated bg
- --text-sm font size
- --radius-sm border-radius
- Arrow pointing to trigger
- Fade in after 500ms delay

### 5.6 Modals

**Overlay:** rgba(0, 0, 0, 0.6) backdrop
**Modal:** --bg-surface, --radius-xl, --shadow-lg
**Header:** Title + close button
**Footer:** Action buttons right-aligned

---

## 6. Technical Approach

### Architecture
- **Framework:** Vanilla HTML/CSS/JavaScript (for maximum portability)
- **No build step required** - runs directly in browser
- **Modular CSS** - component-based architecture
- **ES6+ JavaScript** - clean, modern code

### File Structure
```
/LinkUp-Studio
├── index.html           # Main entry point
├── SPEC.md              # This specification
├── css/
│   ├── variables.css    # Design tokens
│   ├── base.css         # Reset, typography
│   ├── components.css   # UI components
│   ├── layout.css       # Layout system
│   └── animations.css   # Motion utilities
├── js/
│   ├── app.js           # Main application
│   ├── sidebar.js       # Sidebar logic
│   ├── command-palette.js
│   ├── terminal.js      # Terminal component
│   └── activity.js      # Activity panel
└── assets/
    └── icons/           # SVG icons (inline preferred)
```

### Performance Targets
- First paint: < 500ms
- Interactive: < 1000ms
- Smooth 60fps animations

### Accessibility
- Keyboard navigation throughout
- ARIA labels on interactive elements
- Focus management in modals
- Color contrast ratio: 4.5:1 minimum

---

## 7. Inspirations & References

| App | Element |
|-----|---------|
| GitHub Dark | Color palette, typography, spacing |
| GitHub Desktop | Sidebar layout, activity feed |
| Linear | Issue cards, spatial design, polish |
| Raycast | Command palette, search UX |
| Arc Browser | Sidebar navigation, tab concepts |
| Warp Terminal | Terminal aesthetics, cursor design |
| Apple HIG | Animation principles, touch targets |

---

## 8. Implementation Priority

1. **Phase 1:** Core Layout (title bar, sidebar, main area, status bar)
2. **Phase 2:** Design System (CSS variables, base components)
3. **Phase 3:** Command Palette
4. **Phase 4:** Activity Panel
5. **Phase 5:** Terminal Component
6. **Phase 6:** Polish & Animations

---

*This specification serves as the single source of truth for LinkUp Studio's design and implementation.*