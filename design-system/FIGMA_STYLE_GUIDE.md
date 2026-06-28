# LinkUp Studio Figma Style Guide

**Version 1.0.0** | **For Figma Designers**

---

## Overview

This guide provides specifications for recreating the LinkUp Studio design system in Figma. Use these styles to ensure consistency across all design files.

---

## Color Styles

### Create Color Styles in Figma

1. Select **Assets** panel → **Styles** → **+** (Create styles)
2. Name styles using the naming convention: `Color/Category/Name`
3. Apply to all elements using **Fill**, **Stroke**, or **Effect**

### Background Colors

| Figma Style | Hex | Usage |
|--------------|-----|-------|
| `Color/Background/Canvas` | #0D1117 | Main canvas |
| `Color/Background/Surface` | #161B22 | Cards, panels |
| `Color/Background/Elevated` | #21262D | Modals, dropdowns |
| `Color/Background/Overlay` | #30363D | Tooltips, hover |
| `Color/Background/Inset` | #010409 | Terminal, code |

### Border Colors

| Figma Style | Hex | Usage |
|--------------|-----|-------|
| `Color/Border/Default` | #30363D | Standard borders |
| `Color/Border/Muted` | #21262D | Subtle dividers |
| `Color/Border/Accent` | rgba(56,139,253,0.4) | Focus rings |

### Text Colors

| Figma Style | Hex | Usage |
|--------------|-----|-------|
| `Color/Text/Primary` | #E6EDF3 | Primary content |
| `Color/Text/Secondary` | #8B949E | Labels |
| `Color/Text/Tertiary` | #6E7681 | Hints |
| `Color/Text/Disabled` | #484F58 | Disabled |
| `Color/Text/Link` | #58A6FF | Links |

### Accent Colors

| Figma Style | Hex | Usage |
|--------------|-----|-------|
| `Color/Accent/FG` | #58A6FF | Primary accent |
| `Color/Accent/Emphasis` | #1F6FEB | Buttons |
| `Color/Accent/Muted` | rgba(56,139,253,0.15) | Accent backgrounds |

### Semantic Colors

| Figma Style | Hex | Usage |
|--------------|-----|-------|
| `Color/Semantic/Success/FG` | #3FB950 | Success |
| `Color/Semantic/Warning/FG` | #D29922 | Warning |
| `Color/Semantic/Danger/FG` | #F85149 | Danger |
| `Color/Semantic/Info/FG` | #39C5CF | Info |

---

## Text Styles

### Create Text Styles in Figma

1. Select **Assets** panel → **Styles** → **+** → **Text**
2. Apply properties: Font, Size, Weight, Line Height, Letter Spacing

### Font Setup

**Font Family:** Inter (download from [fonts.google.com](https://fonts.google.com/specimen/Inter))
**Fallback:** SF Pro Display, system-ui

### Heading Styles

| Figma Style | Font | Size | Weight | Line Height | Letter Spacing |
|--------------|------|------|--------|-------------|----------------|
| `Text/H1` | Inter | 24px | 700 | 1.25 | -0.02em |
| `Text/H2` | Inter | 20px | 600 | 1.25 | -0.01em |
| `Text/H3` | Inter | 16px | 600 | 1.5 | 0 |
| `Text/H4` | Inter | 15px | 500 | 1.5 | 0 |

### Body Styles

| Figma Style | Font | Size | Weight | Line Height |
|--------------|------|------|--------|-------------|
| `Text/Body` | Inter | 14px | 400 | 1.5 |
| `Text/Body Small` | Inter | 12px | 400 | 1.5 |
| `Text/Caption` | Inter | 11px | 400 | 1.4 |

### Button Styles

| Figma Style | Font | Size | Weight | Line Height |
|--------------|------|------|--------|-------------|
| `Text/Button` | Inter | 12px | 500 | 1 |
| `Text/Button Small` | Inter | 11px | 500 | 1 |

### Code Styles

| Figma Style | Font | Size | Weight | Line Height |
|--------------|------|------|--------|-------------|
| `Text/Code` | JetBrains Mono | 12px | 400 | 1.4 |
| `Text/KBD` | Inter | 11px | 500 | 1 |

---

## Effect Styles (Shadows)

### Create Effect Styles

1. Select **Assets** panel → **Styles** → **+** → **Effect**
2. Choose Shadow type and configure values

### Shadow Styles

| Figma Style | Type | X | Y | Blur | Spread | Color | Opacity |
|-------------|------|---|---|------|--------|-------|---------|
| `Effect/Shadow/Small` | Drop Shadow | 0 | 1px | 2px | 0 | #000000 | 30% |
| `Effect/Shadow/Medium` | Drop Shadow | 0 | 4px | 12px | 0 | #000000 | 40% |
| `Effect/Shadow/Large` | Drop Shadow | 0 | 8px | 24px | 0 | #000000 | 50% |
| `Effect/Shadow/Focus` | Drop Shadow | 0 | 0 | 0 | 3px | #388BFD | 30% |

---

## Component Specifications

### Buttons

#### Primary Button
```
Width: Auto (min 60px)
Height: 32px
Padding: 12px horizontal
Fill: #1F6FEB
Border: None
Corner Radius: 6px
Text: #FFFFFF, 12px, 500
```

#### Secondary Button
```
Width: Auto (min 60px)
Height: 32px
Padding: 12px horizontal
Fill: #21262D
Border: 1px #30363D
Corner Radius: 6px
Text: #E6EDF3, 12px, 500
```

#### Ghost Button
```
Width: Auto (min 60px)
Height: 32px
Padding: 12px horizontal
Fill: None
Border: None
Corner Radius: 6px
Text: #8B949E, 12px, 500
```

### Inputs

#### Text Input
```
Width: 240px (or Auto)
Height: 36px
Padding: 0 12px
Fill: #161B22
Border: 1px #30363D
Corner Radius: 6px
Text: #E6EDF3, 14px, 400
Placeholder: #6E7681
```

#### Search Input
```
Width: 100% (or Auto)
Height: 36px
Padding: 0 80px 0 36px
Fill: #161B22
Border: 1px #30363D
Corner Radius: 6px
Icon: 16px, #6E7681, left 12px
Shortcut: #6E7681, right 12px
```

### Cards

#### Base Card
```
Width: Auto (min 200px)
Padding: 16px
Fill: #161B22
Border: 1px #21262D
Corner Radius: 8px
Shadow: Medium (hover)
```

### Icons

| Size | Stroke Weight | Usage |
|------|---------------|-------|
| 12px | 1.5px | Inline with text |
| 16px | 1.5px | Default, sidebar |
| 20px | 1.5px | Toolbar |
| 24px | 1.5px | Feature icons |

---

## Spacing in Figma

### Auto Layout

Use **Auto Layout** for consistent spacing:

```
Row Padding: 8px 12px
Column Gap: 8px
Card Padding: 16px
Section Gap: 24px
```

### Spacing Tokens

| Token | Pixels | Figma Value |
|-------|--------|-------------|
| xs | 4px | 4 |
| sm | 8px | 8 |
| md | 12px | 12 |
| lg | 16px | 16 |
| xl | 24px | 24 |
| 2xl | 32px | 32 |

---

## Border Radius in Figma

### Shape Properties

| Element | Corner Radius |
|---------|---------------|
| Buttons | 6px |
| Inputs | 6px |
| Cards | 8px |
| Dialogs | 12px |
| Badges | 9999px (pill) |
| Avatars | 9999px (circle) |

---

## Layout Grid

### Page Grid

```
Columns: 12
Gutter: 24px
Margin: 48px
Max Width: 1440px
```

### Sidebar Layout

```
Width: 56px (collapsed)
Width: 240px (expanded)
Item Height: 40px
Item Padding: 8px
Icon Size: 22px
```

### Title Bar

```
Height: 32px
Icon Size: 16px
```

### Status Bar

```
Height: 24px
```

---

## Color Palette Export

### Primary Palette

```
#0D1117 - Canvas (Background)
#161B22 - Surface
#21262D - Elevated
#30363D - Overlay / Borders
#E6EDF3 - Primary Text
#8B949E - Secondary Text
#6E7681 - Tertiary Text
#58A6FF - Accent Blue
#1F6FEB - Accent Emphasis
```

### Semantic Palette

```
#3FB950 - Success
#D29922 - Warning
#F85149 - Danger
#A371F7 - Purple
#F0883E - Orange
```

---

## Figma Tips

### Quick Selection

- Use **Shift+Click** to select multiple elements
- Use **⌘+E** for quick export
- Use **⌘+D** to duplicate

### Color Picker

- Press **I** for color picker
- Use **Shift+C** to copy color

### Alignment

- Use **⌘+Shift+A** to align center
- Use **⌘+Option+M** to center in parent

---

## Icon Export Specifications

### When exporting icons from Figma:

1. **Select icon frame** (16x16 or 24x24)
2. **Right-click** → **Export** → **SVG**
3. **Settings**:
   - ✓ Include "id" attribute
   - ✗ Simplify stroke
   - ✗ Outline text

### SVG Code Style

```svg
<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M..." fill="currentColor"/>
</svg>
```

---

## Dark Mode Preview

To preview dark mode in Figma:

1. Select **View** → **Dark UI**
2. Or use **Figma Dark Mode Plugin**

---

## Version History

| Version | Date | Changes |
|---------|------|--------|
| 1.0.0 | 2024 | Initial release |

---

## Resources

- **Inter Font**: https://fonts.google.com/specimen/Inter
- **JetBrains Mono**: https://www.jetbrains.com/lp/mono/
- **Figma Community**: Search "LinkUp Studio"

---

**LinkUp Studio Figma Style Guide v1.0.0**

*For designers, by designers.*
