# LinkUp Studio Design System

**Version 1.0.0** | **Last Updated: 2024**

---

## Table of Contents

1. [Overview](#overview)
2. [Design Principles](#design-principles)
3. [Typography](#typography)
4. [Color System](#color-system)
5. [Spacing System](#spacing-system)
6. [Border Radius](#border-radius)
7. [Shadows](#shadows)
8. [Button System](#button-system)
9. [Input System](#input-system)
10. [Icons](#icons)
11. [Animations](#animations)
12. [Layout](#layout)
13. [Components](#components)
14. [Accessibility](#accessibility)

---

## Overview

LinkUp Studio Design System is the foundation for creating a premium developer interface. Inspired by GitHub Dark, Linear, Raycast, Arc Browser, and Apple Human Interface Guidelines, this system ensures consistency, elegance, and developer-first experiences.

### Design Goals

- **Modern** - Clean, contemporary aesthetic
- **Elegant** - Refined details, thoughtful spacing
- **Minimal** - No visual noise, purposeful elements
- **Developer First** - Built for developers, by developers
- **Fast** - Quick to load, responsive interactions
- **Professional** - Production-ready, enterprise quality

---

## Design Principles

### 1. Darkness with Purpose

Every dark theme has a reason. Our palette uses deep blacks with subtle purple undertones:

```
Canvas: #0d1117 (deepest)
Surface: #161b22 (elevated)
Elevated: #21262d (highest)
```

### 2. Content Hierarchy

Use typography scale and color to establish clear hierarchy:

1. **Primary** - Main content, headings
2. **Secondary** - Supporting content, labels
3. **Tertiary** - Hints, timestamps, metadata

### 3. Spacing Rhythm

Consistent 4px-based spacing creates visual rhythm:

```
4px   - Icon gaps, tight spacing
8px   - Default element spacing
16px  - Component padding
24px  - Section spacing
32px  - Major section gaps
```

### 4. Purposeful Motion

Animations communicate state changes. Every animation should:

- Be **purposeful** - communicate meaning
- Be **swift** - 150-300ms is ideal
- Be **subtle** - felt, not seen

---

## Typography

### Font Stack

```css
--font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', 'Cascadia Code', Consolas, monospace;
```

### Type Scale

| Name | Size | Pixels | Usage |
|------|------|--------|-------|
| 2xs | 0.625rem | 10px | Timestamps, badges |
| xs | 0.6875rem | 11px | Small labels |
| sm | 0.75rem | 12px | Secondary text, buttons |
| base | 0.875rem | 14px | Body text |
| md | 0.9375rem | 15px | Emphasized body |
| lg | 1rem | 16px | Section headers |
| xl | 1.25rem | 20px | Panel titles |
| 2xl | 1.5rem | 24px | Main headings |
| 3xl | 1.875rem | 30px | Hero headings |

### Font Weights

| Weight | Value | Usage |
|--------|-------|-------|
| Normal | 400 | Body text |
| Medium | 500 | Subheadings, emphasis |
| Semibold | 600 | Section headers |
| Bold | 700 | Main headings |

### Line Heights

| Context | Value | Usage |
|---------|-------|-------|
| Tight | 1.25 | Headings |
| Normal | 1.5 | Body text |
| Relaxed | 1.625 | Long-form content |
| Mono | 1.4 | Code, terminal |

### Usage Examples

```css
/* Headings */
h1 { font-size: var(--text-2xl); font-weight: var(--font-weight-bold); line-height: var(--line-height-tight); }
h2 { font-size: var(--text-xl); font-weight: var(--font-weight-semibold); line-height: var(--line-height-tight); }
h3 { font-size: var(--text-lg); font-weight: var(--font-weight-semibold); }

/* Body */
body { font-size: var(--text-base); font-weight: var(--font-weight-normal); line-height: var(--line-height-normal); }

/* Code */
code, pre { font-family: var(--font-mono); font-size: var(--text-sm); line-height: var(--line-height-mono); }

/* Buttons */
.btn { font-size: var(--text-sm); font-weight: var(--font-weight-medium); }

/* Terminal */
.terminal { font-family: var(--font-mono); font-size: var(--text-sm); line-height: var(--line-height-mono); }
```

---

## Color System

### Background Layers

```
┌─────────────────────────────────────┐
│  Canvas (#0d1117) - Main canvas      │
│  ┌─────────────────────────────────┐│
│  │  Surface (#161b22) - Cards       ││
│  │  ┌─────────────────────────────┐ ││
│  │  │  Elevated (#21262d)        │ ││
│  │  │  Modals, dropdowns          │ ││
│  │  └─────────────────────────────┘ ││
│  └─────────────────────────────────┘│
└─────────────────────────────────────┘
```

### Color Variables

```css
/* Backgrounds */
--bg-canvas: #0d1117;
--bg-surface: #161b22;
--bg-elevated: #21262d;
--bg-overlay: #30363d;
--bg-inset: #010409;

/* Borders */
--border-default: #30363d;
--border-muted: #21262d;
--border-accent: rgba(56, 139, 253, 0.4);
--border-active: #58a6ff;

/* Text */
--text-primary: #e6edf3;
--text-secondary: #8b949e;
--text-tertiary: #6e7681;
--text-disabled: #484f58;
--text-link: #58a6ff;
```

### Semantic Colors

| State | Foreground | Background | Usage |
|-------|-----------|------------|-------|
| Success | `#3fb950` | `rgba(63, 185, 80, 0.15)` | Completed actions |
| Warning | `#d29922` | `rgba(210, 153, 34, 0.15)` | Caution needed |
| Danger | `#f85149` | `rgba(248, 81, 73, 0.15)` | Errors, destructive |
| Info | `#39c5cf` | `rgba(57, 197, 207, 0.15)` | Information |

### Accent Colors

| Name | Value | Usage |
|------|-------|-------|
| Accent FG | `#58a6ff` | Links, primary actions |
| Accent Emphasis | `#1f6feb` | Button backgrounds |
| Purple | `#a371f7` | Special highlights |
| Orange | `#f0883e` | Notifications |

---

## Spacing System

### 4px-Based Scale

```
┌────────────────────────────────────────────────┐
│  4px   - Icon gaps                             │
│  8px   - Tight spacing, default element gaps   │
│  12px  - Input padding horizontal              │
│  16px  - Default component padding             │
│  20px  - Button padding horizontal             │
│  24px  - Section gaps, dialog padding          │
│  32px  - Major section margins                  │
│  40px  - Large section spacing                 │
│  48px  - Card padding, major gaps              │
│  64px  - Page section margins                   │
└────────────────────────────────────────────────┘
```

### CSS Variables

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
--space-16: 64px;
```

### Common Usage

```css
/* Icon spacing */
.icon + .icon { margin-left: var(--space-1); }

/* Button padding */
.btn { padding: var(--space-2) var(--space-3); }
.btn-sm { padding: var(--space-1) var(--space-2); }
.btn-lg { padding: var(--space-3) var(--space-4); }

/* Input padding */
.input { padding: var(--space-2) var(--space-3); }

/* Card padding */
.card { padding: var(--space-4); }

/* Section gap */
.section { margin-bottom: var(--space-8); }

/* Dialog padding */
.dialog { padding: var(--space-6); }
```

---

## Border Radius

### Scale

| Name | Value | Usage |
|------|-------|-------|
| None | 0px | Full-bleed elements, windows |
| sm | 4px | Badges, tags, checkboxes |
| md | 6px | Buttons, inputs, tooltips |
| lg | 8px | Cards, panels, dropdowns |
| xl | 12px | Dialogs, command palette |
| full | 9999px | Pills, avatars, toggles |

### Component Usage

```css
/* Buttons & Inputs */
.btn, .input, .search-input { border-radius: var(--radius-md); }

/* Cards & Panels */
.card, .panel, .dropdown { border-radius: var(--radius-lg); }

/* Dialogs & Modals */
.dialog, .modal, .command-palette { border-radius: var(--radius-xl); }

/* Badges & Tags */
.badge, .tag { border-radius: var(--radius-full); }

/* Avatars */
.avatar { border-radius: var(--radius-full); }

/* Toggle */
.switch { border-radius: var(--radius-full); }

/* No radius - full-bleed */
.titlebar, .sidebar, .statusbar, .window { border-radius: 0; }
```

---

## Shadows

### Shadow Scale

| Name | Value | Usage |
|------|-------|-------|
| xs | `0 1px 0 rgba(27, 31, 36, 0.04)` | Subtle depth |
| sm | `0 1px 2px rgba(0, 0, 0, 0.3)` | Small elements |
| md | `0 4px 12px rgba(0, 0, 0, 0.4)` | Cards, panels |
| lg | `0 8px 24px rgba(0, 0, 0, 0.5)` | Dropdowns, popovers |
| xl | `0 16px 48px rgba(0, 0, 0, 0.6)` | Modals, dialogs |

### Glow Shadows

```css
/* Focus ring */
--shadow-glow: 0 0 0 3px rgba(56, 139, 253, 0.3);

/* Success focus */
--shadow-glow-success: 0 0 0 3px rgba(63, 185, 80, 0.3);

/* Danger focus */
--shadow-glow-danger: 0 0 0 3px rgba(248, 81, 73, 0.3);
```

### Usage

```css
/* Card hover */
.card:hover { box-shadow: var(--shadow-md); }

/* Dropdown */
.dropdown { box-shadow: var(--shadow-lg); }

/* Modal */
.modal { box-shadow: var(--shadow-xl); }

/* Focus state */
.input:focus { box-shadow: var(--shadow-glow); }
```

---

## Button System

### Button Variants

| Variant | Background | Border | Text | Usage |
|---------|-----------|--------|------|-------|
| Primary | `#1f6feb` | transparent | white | Main actions |
| Secondary | `#21262d` | `#30363d` | `#e6edf3` | Secondary actions |
| Ghost | transparent | transparent | `#8b949e` | Tertiary actions |
| Danger | `#da3633` | transparent | white | Destructive |
| Success | `#238636` | transparent | white | Positive |

### Button Sizes

| Size | Height | Padding | Font Size |
|------|--------|---------|-----------|
| sm | 28px | 4px 8px | 11px |
| md (default) | 32px | 8px 12px | 12px |
| lg | 40px | 12px 16px | 14px |

### Button States

```css
/* Default */
.btn {
  height: 32px;
  padding: 0 12px;
  font-size: 12px;
  font-weight: 500;
  border-radius: 6px;
  transition: all 150ms ease-out;
}

/* Hover */
.btn:hover { background: #2d7ff9; }

/* Active */
.btn:active { background: #1967d2; transform: translateY(1px); }

/* Disabled */
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

/* Focus */
.btn:focus-visible {
  outline: 2px solid var(--accent-fg);
  outline-offset: 2px;
}
```

### Icon Buttons

```css
.btn-icon {
  width: 32px;
  height: 32px;
  padding: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.btn-icon.btn-sm { width: 28px; height: 28px; }
.btn-icon.btn-lg { width: 40px; height: 40px; }
```

---

## Input System

### Text Input

```css
.input {
  height: 36px;
  padding: 0 12px;
  font-size: 14px;
  background: var(--bg-surface);
  border: 1px solid var(--border-default);
  border-radius: 6px;
  color: var(--text-primary);
  transition: all 150ms ease-out;
}

.input:hover { border-color: var(--border-subtle); }

.input:focus {
  border-color: var(--accent-fg);
  box-shadow: 0 0 0 3px rgba(56, 139, 253, 0.3);
}

.input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.input::placeholder {
  color: var(--text-placeholder);
}
```

### Search Input

```css
.search-input {
  position: relative;
  display: flex;
  align-items: center;
}

.search-input input {
  width: 100%;
  height: 36px;
  padding: 0 12px 0 36px;
}

.search-input .search-icon {
  position: absolute;
  left: 12px;
  color: var(--text-tertiary);
}

.search-input .search-shortcut {
  position: absolute;
  right: 12px;
  color: var(--text-tertiary);
}
```

### Form Elements

| Element | Height | Radius | Notes |
|---------|--------|--------|-------|
| Text Input | 36px | 6px | Standard input |
| Textarea | min 100px | 6px | Multi-line |
| Select | 36px | 6px | Dropdown select |
| Checkbox | 16px | 4px | Square |
| Radio | 16px | full | Circle |
| Toggle | 22px × 40px | full | Switch |

### Checkbox & Radio

```css
.checkbox, .radio {
  width: 16px;
  height: 16px;
  border: 1px solid var(--border-default);
  background: var(--bg-surface);
  cursor: pointer;
  appearance: none;
  display: flex;
  align-items: center;
  justify-content: center;
}

.checkbox { border-radius: 4px; }
.radio { border-radius: 9999px; }

.checkbox:checked {
  background: var(--accent-emphasis);
  border-color: var(--accent-emphasis);
}

.checkbox:checked::after {
  content: '✓';
  color: white;
  font-size: 10px;
}
```

### Toggle/Switch

```css
.switch {
  position: relative;
  width: 40px;
  height: 22px;
  background: var(--bg-overlay);
  border-radius: 9999px;
  cursor: pointer;
  transition: background 150ms ease-out;
}

.switch::after {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  width: 16px;
  height: 16px;
  background: white;
  border-radius: 9999px;
  transition: transform 150ms ease-out;
}

.switch.active { background: var(--accent-emphasis); }
.switch.active::after { transform: translateX(18px); }
```

---

## Icons

### Icon System

- **Grid**: 16×16px base grid
- **Stroke**: 1.5px consistent stroke
- **Style**: Rounded corners, outline style
- **Color**: `currentColor` for inheritance

### Icon Sizes

| Size | Class | Usage |
|------|-------|-------|
| 12px | `.icon-xs` | Inline with text |
| 14px | `.icon-sm` | Sidebar icons |
| 16px | `.icon` | Default |
| 20px | `.icon-md` | Toolbar |
| 24px | `.icon-lg` | Feature icons |
| 32px | `.icon-xl` | Empty states |

### Icon CSS

```css
.icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  flex-shrink: 0;
}

.icon svg {
  width: 100%;
  height: 100%;
  fill: currentColor;
}
```

---

## Animations

### Duration Scale

| Name | Value | Usage |
|------|-------|-------|
| Instant | 50ms | Hover states |
| Fast | 150ms | Small transitions |
| Normal | 250ms | Panel transitions |
| Slow | 400ms | Major changes |
| Slower | 600ms | Page transitions |

### Easing Functions

```css
--ease-out: cubic-bezier(0.16, 1, 0.3, 1);      /* Natural deceleration */
--ease-in-out: cubic-bezier(0.65, 0, 0.35, 1);    /* Balanced */
--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1); /* Bouncy */
```

### Common Animations

```css
/* Fade In */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* Fade In Up */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

/* Scale In */
@keyframes scaleIn {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

/* Blink (cursor) */
@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
}
```

### Transition Usage

```css
/* Hover transition */
.hover-lift {
  transition: transform 150ms ease-out, box-shadow 150ms ease-out;
}

.hover-lift:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-md);
}

/* Button transition */
.btn {
  transition: background-color 150ms ease-out,
              border-color 150ms ease-out,
              color 150ms ease-out,
              box-shadow 150ms ease-out;
}
```

---

## Layout

### Application Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│  Title Bar (32px)                                                   │
├────────┬────────────────────────────────────────┬────────────────────┤
│        │                                        │                    │
│ Sidebar│  Main Content Area                    │  Activity Panel    │
│ (56px) │                                        │  (320px)          │
│        │  ┌──────────────────────────────────┐  │                    │
│        │  │  Tab Bar (36px)                 │  │                    │
│        │  ├──────────────────────────────────┤  │                    │
│        │  │                                  │  │                    │
│        │  │  Editor / Workspace              │  │                    │
│        │  │                                  │  │                    │
│        │  │                                  │  │                    │
│        │  └──────────────────────────────────┘  │                    │
│        │                                        │                    │
│        │  ┌──────────────────────────────────┐  │                    │
│        │  │  Terminal                        │  │                    │
│        │  └──────────────────────────────────┘  │                    │
├────────┴────────────────────────────────────────┴────────────────────┤
│  Status Bar (24px)                                                 │
└─────────────────────────────────────────────────────────────────────┘
```

### Layout Variables

```css
--titlebar-height: 32px;
--sidebar-width: 56px;
--sidebar-width-expanded: 240px;
--activity-panel-width: 320px;
--statusbar-height: 24px;
--tab-height: 36px;
```

### Grid System

```css
.app-layout {
  display: grid;
  grid-template-rows: var(--titlebar-height) 1fr var(--statusbar-height);
  grid-template-columns: var(--sidebar-width) 1fr;
  grid-template-areas:
    "titlebar titlebar"
    "sidebar main"
    "statusbar statusbar";
  width: 100vw;
  height: 100vh;
}

.app-layout.with-activity {
  grid-template-columns: var(--sidebar-width) 1fr var(--activity-panel-width);
  grid-template-areas:
    "titlebar titlebar titlebar"
    "sidebar main activity"
    "statusbar statusbar statusbar";
}
```

---

## Components

### Card

```css
.card {
  background: var(--bg-surface);
  border: 1px solid var(--border-muted);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
  transition: all var(--duration-fast) var(--ease-out);
}

.card:hover {
  border-color: var(--border-default);
  box-shadow: var(--shadow-md);
  transform: translateY(-1px);
}
```

### Dialog/Modal

```css
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(8px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: var(--z-modal);
  opacity: 0;
  visibility: hidden;
  transition: all var(--duration-normal) var(--ease-out);
}

.modal-overlay.open {
  opacity: 1;
  visibility: visible;
}

.modal {
  width: 100%;
  max-width: 480px;
  background: var(--bg-surface);
  border: 1px solid var(--border-default);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-xl);
  transform: scale(0.95) translateY(10px);
  transition: transform var(--duration-normal) var(--ease-spring);
}

.modal-overlay.open .modal {
  transform: scale(1) translateY(0);
}
```

### Tooltip

```css
.tooltip {
  position: absolute;
  padding: 6px 8px;
  background: var(--bg-elevated);
  border: 1px solid var(--border-default);
  border-radius: var(--radius-md);
  font-size: var(--text-sm);
  color: var(--text-primary);
  white-space: nowrap;
  z-index: var(--z-tooltip);
  opacity: 0;
  visibility: hidden;
  transition: opacity var(--duration-fast) var(--ease-out);
}

.tooltip.show {
  opacity: 1;
  visibility: visible;
}
```

### Scrollbar

```css
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: transparent;
}

::-webkit-scrollbar-thumb {
  background: #424242;
  border-radius: 9999px;
  border: 2px solid transparent;
  background-clip: padding-box;
}

::-webkit-scrollbar-thumb:hover {
  background: #525252;
}
```

---

## Accessibility

### Focus States

```css
/* Visible focus indicator */
:focus-visible {
  outline: 2px solid var(--accent-fg);
  outline-offset: 2px;
}

/* Remove default focus */
:focus { outline: none; }
```

### Color Contrast

All text combinations meet WCAG AA standards:

| Combination | Ratio | Level |
|------------|-------|-------|
| Primary on Canvas | 14.4:1 | AAA |
| Secondary on Canvas | 5.8:1 | AA |
| Primary on Surface | 11.4:1 | AAA |
| Secondary on Surface | 4.6:1 | AA |

### Keyboard Navigation

```css
/* Focus trap for modals */
.modal:focus-trap {
  position: fixed;
  inset: 0;
}

/* Skip link */
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  padding: 8px 16px;
  background: var(--accent-emphasis);
  color: white;
  z-index: 9999;
}

.skip-link:focus {
  top: 0;
}
```

### Screen Reader Only

```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

---

## Z-Index Scale

```css
--z-base: 0;
--z-dropdown: 100;
--z-sticky: 200;
--z-overlay: 300;
--z-modal: 400;
--z-popover: 500;
--z-tooltip: 600;
--z-toast: 700;
```

---

## Implementation

### CSS Variables File

```css
/* variables.css */
:root {
  /* Colors */
  --bg-canvas: #0d1117;
  --bg-surface: #161b22;
  --bg-elevated: #21262d;
  --bg-overlay: #30363d;
  --border-default: #30363d;
  --text-primary: #e6edf3;
  --accent-fg: #58a6ff;
  
  /* Typography */
  --font-sans: 'Inter', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
  --text-sm: 0.75rem;
  
  /* Spacing */
  --space-1: 4px;
  --space-2: 8px;
  --space-4: 16px;
  
  /* Radius */
  --radius-md: 6px;
  --radius-lg: 8px;
  
  /* Motion */
  --duration-fast: 150ms;
  --ease-out: cubic-bezier(0.16, 1, 0.3, 1);
}
```

---

## Quick Reference

### Common Patterns

```css
/* Default card */
.card {
  background: var(--bg-surface);
  border: 1px solid var(--border-muted);
  border-radius: var(--radius-lg);
  padding: var(--space-4);
}

/* Default button */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 32px;
  padding: 0 var(--space-3);
  font-size: var(--text-sm);
  font-weight: 500;
  border-radius: var(--radius-md);
  transition: all var(--duration-fast) var(--ease-out);
}

/* Default input */
.input {
  height: 36px;
  padding: 0 var(--space-3);
  font-size: var(--text-base);
  background: var(--bg-surface);
  border: 1px solid var(--border-default);
  border-radius: var(--radius-md);
}
```

---

**LinkUp Studio Design System v1.0.0**

*Built with purpose. Designed for developers.*
