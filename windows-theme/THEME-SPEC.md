# LinkUp Studio Windows Theme - GitHub Dark

A complete Windows 10/11 dark theme package inspired by GitHub's dark color scheme.

## 🎨 Overview

This theme transforms your Windows experience with the GitHub Dark color palette, providing a cohesive, professional dark mode across all system elements.

## 📦 Contents

| File | Description |
|------|-------------|
| `GitHubDark.theme` | Windows personal theme file |
| `GitHubDark.msstyles` | Visual styles for Windows elements |
| `GitHubDark.wallpaper.png` | High-resolution wallpaper |
| `activate-dark-mode.reg` | Registry tweaks for system-wide dark mode |
| `install-theme.bat` | Theme installation script |
| `README.md` | Installation guide |

---

## 🎨 Color Palette

### Base Backgrounds

| Token | Hex | Usage |
|-------|-----|-------|
| `--bg-canvas` | `#0d1117` | Deepest layer - main canvas, desktop |
| `--bg-surface` | `#161b22` | Elevated surfaces - panels, cards |
| `--bg-elevated` | `#21262d` | Highest elevation - modals, dropdowns |
| `--bg-overlay` | `#30363d` | Overlays - hover states, tooltips |

### Text Hierarchy

| Token | Hex | Usage |
|-------|-----|-------|
| `--text-primary` | `#e6edf3` | Primary content, headings |
| `--text-secondary` | `#8b949e` | Secondary text, labels |
| `--text-tertiary` | `#6e7681` | Disabled, hints, timestamps |

### Accent Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `--accent-fg` | `#58a6ff` | Links, focus states |
| `--accent-emphasis` | `#1f6feb` | Primary buttons, active states |
| `--accent-muted` | `#388bfd26` | Accent backgrounds |

### Semantic Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `--success-fg` | `#3fb950` | Success messages, online status |
| `--warning-fg` | `#d29922` | Warnings, attention needed |
| `--danger-fg` | `#f85149` | Errors, destructive actions |
| `--done-fg` | `#a371f7` | Purple accents, special states |

### Borders

| Token | Hex | Usage |
|-------|-----|-------|
| `--border-default` | `#30363d` | Standard borders |
| `--border-muted` | `#21262d` | Subtle dividers |
| `--border-accent` | `#388bfd40` | Focus rings, active borders |

---

## 🖼️ Explorer Appearance

### Folder Background
- **Background:** `#0d1117` (--bg-canvas)
- **Item hover:** `#21262d` with subtle border
- **Selected item:** `#1f6feb20` background with `#388bfd` border

### File/Folder Icons
- **Default:** `#8b949e` color
- **Hover:** `#e6edf3` color
- **Selected:** `#58a6ff` color

### Navigation Pane
- **Background:** `#161b22`
- **Headings:** `#8b949e` uppercase
- **Items:** `#e6edf3` with hover `#21262d`

### Details Pane
- **Background:** `#161b22`
- **Dividers:** `#21262d`
- **Labels:** `#8b949e`
- **Values:** `#e6edf3`

---

## 📌 Taskbar Appearance

### Taskbar Background
- **Color:** `#161b22` (90% opacity)
- **Border top:** `1px solid #30363d`
- **Blur effect:** Subtle glass morphism on Windows 11

### App Icons
- **Default:** `#8b949e`
- **Hover:** `#e6edf3`
- **Active/Open:** `#58a6ff` indicator dot

### Start Button
- **Icon:** GitHub octicon in `#e6edf3`
- **Hover:** `#21262d` background
- **Active:** `#1f6feb` border accent

### System Tray
- **Background:** Transparent
- **Icons:** `#8b949e`
- **Hover:** `#21262d` background
- **Notification badge:** `#f85149`

### Clock
- **Text:** `#e6edf3`
- **Secondary:** `#8b949e` for date

---

## 🏠 Start Menu Appearance

### Background
- **Color:** `#161b22` with `#0d1117` gradient
- **Border:** `1px solid #30363d`
- **Blur:** 20px backdrop blur

### Search Bar
- **Background:** `#21262d`
- **Border:** `1px solid #30363d`
- **Focus:** `#388bfd40` border
- **Placeholder:** `#6e7681`

### Pinned Apps
- **Tile background:** `#21262d`
- **Tile hover:** `#30363d`
- **Icon:** `#e6edf3`
- **Label:** `#e6edf3`

### Recommended Section
- **Background:** `#161b22`
- **Item hover:** `#21262d`
- **Recent files:** `#58a6ff` accent

### Power Button
- **Background:** `#21262d`
- **Icon:** `#8b949e`
- **Hover:** `#f85149` for shutdown

---

## 🪟 Window Borders

### Title Bar
- **Background:** `#161b22`
- **Text:** `#e6edf3`
- **Close button hover:** `#f85149`
- **Maximize/Minimize hover:** `#21262d`

### Window Frame
- **Border:** `1px solid #30363d`
- **Shadow:** `0 8px 24px rgba(0,0,0,0.4)`
- **Corners:** 8px radius on Windows 11

### Active vs Inactive
- **Active:** Full opacity, `#30363d` border
- **Inactive:** 80% opacity, `#21262d` border

### Snap Layouts
- **Border:** `#58a6ff` when dragging
- **Preview:** `#1f6feb40` fill

---

## 💎 Accent Colors

### Primary Accent (Blue)
| State | Background | Border |
|-------|------------|--------|
| Default | `#1f6feb` | - |
| Hover | `#2d7ff9` | - |
| Active | `#1967d2` | - |
| Disabled | `#1f6feb50` | - |

### Focus Ring
- **Color:** `#388bfd`
- **Width:** 2px
- **Offset:** 2px
- **Opacity:** 40%

### Progress Bars
- **Track:** `#21262d`
- **Fill:** `#1f6feb`
- **Indeterminate:** Animated `#58a6ff`

### Sliders
- **Track:** `#30363d`
- **Fill:** `#1f6feb`
- **Thumb:** `#e6edf3`
- **Thumb hover:** `#58a6ff`

---

## 📋 Context Menus

### Menu Background
- **Background:** `#161b22`
- **Border:** `1px solid #30363d`
- **Shadow:** `0 8px 24px rgba(0,0,0,0.4)`
- **Radius:** 8px

### Menu Items
| State | Background | Text | Icon |
|-------|------------|------|------|
| Default | Transparent | `#e6edf3` | `#8b949e` |
| Hover | `#21262d` | `#e6edf3` | `#e6edf3` |
| Selected | `#1f6feb20` | `#e6edf3` | `#58a6ff` |
| Disabled | Transparent | `#6e7681` | `#6e7681` |

### Dividers
- **Color:** `#21262d`
- **Margin:** 4px vertical

### Submenu Arrow
- **Color:** `#8b949e`
- **Hover:** `#e6edf3`

### Keyboard Shortcut Text
- **Color:** `#6e7681`
- **Font:** Monospace

---

## ✓ Selection Colors

### Text Selection
- **Background:** `#388bfd40`
- **Text:** `#e6edf3`

### List/Explorer Selection
| State | Background | Border |
|-------|------------|--------|
| Single | `#1f6feb20` | `#388bfd40` |
| Multi-select | `#1f6feb15` | `#388bfd30` |
| Focused | `#1f6feb30` | `#388bfd60` |

### Checkbox Selection
- **Unchecked:** `#30363d` border
- **Checked:** `#1f6feb` background
- **Checkmark:** `#ffffff`

---

## 👆 Hover Colors

### General Hover
- **Background:** `#21262d`
- **Border:** `#30363d`
- **Transition:** 150ms ease-out

### Button Hover
| Button Type | Hover Background |
|-------------|------------------|
| Primary | `#2d7ff9` |
| Secondary | `#30363d` |
| Ghost | `#21262d` |
| Danger | `#f85149` |

### Link Hover
- **Color:** `#79c0ff`
- **Decoration:** Underline

### Icon Hover
- **Color:** `#e6edf3`
- **Background:** `#21262d40`

### Scrollbar Hover
- **Thumb:** `#525252`
- **Track:** `#30363d`

---

## 🔧 Installation Instructions

### Method 1: Automated Installation
1. Extract the theme package
2. Run `install-theme.bat` as Administrator
3. Restart Windows Explorer

### Method 2: Manual Installation
1. Copy `.theme` and `.msstyles` to:
   `C:\Windows\Resources\Themes\`
2. Copy wallpaper to:
   `C:\Windows\Web\4K\Wallpaper\Windows\`
3. Apply theme via Settings → Personalization → Themes

### Method 3: Registry Tweaks Only
1. Double-click `activate-dark-mode.reg`
2. Restart Windows

---

## ⚠️ Compatibility

- **Windows 10** (1903+) - Full support
- **Windows 11** - Partial support (rounded corners not fully themed)

## 📝 Notes

- Some system elements may require restart to apply
- Third-party apps need their own dark mode settings
- Registry changes require administrator privileges

---

## 🎯 Design Principles

1. **Consistency** - All elements use the same color tokens
2. **Contrast** - WCAG AA compliant (4.5:1 minimum)
3. **Subtlety** - No jarring bright colors
4. **Hierarchy** - Clear visual states for all interactive elements
5. **Performance** - Hardware-accelerated animations

---

*Theme created for LinkUp Studio - Premium Windows Developer Environment*