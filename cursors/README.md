# LinkUp Studio Cursor Pack

Premium Windows cursors inspired by **Apple**, **GitHub**, and **Linear** with GitHub Dark styling.

## 🎨 Cursor Collection

| Cursor | Filename | Description |
|--------|----------|-------------|
| ![Normal](png/32/normal.png) | `normal` | Standard arrow pointer |
| ![Busy](png/32/busy.png) | `busy` | System busy/wait |
| ![Loading](png/32/loading.png) | `loading` | Progress indicator |
| ![Text](png/32/text.png) | `text` | I-beam text cursor |
| ![Resize](png/32/resize.png) | `resize` | Vertical resize (N/S) |
| ![Resize H](png/32/resize-horizontal.png) | `resize-horizontal` | Horizontal resize (E/W) |
| ![Resize D](png/32/resize-diagonal.png) | `resize-diagonal` | Diagonal resize |
| ![Move](png/32/move.png) | `move` | Four-way move |
| ![Precision](png/32/precision.png) | `precision` | Crosshair precision |
| ![Link](png/32/link.png) | `link` | Link hover indicator |
| ![Hand](png/32/hand.png) | `hand` | Open hand grab |

## 📁 File Structure

```
cursors/
├── source/           # SVG source files
├── png/
│   ├── 16/          # 16px cursors
│   ├── 24/          # 24px cursors
│   ├── 32/          # 32px cursors
│   ├── 48/          # 48px cursors
│   ├── 64/          # 64px cursors
│   ├── 96/          # 96px cursors
│   └── 128/         # 128px cursors
├── cur/              # Windows .cur files
├── css/
│   └── cursors.css  # CSS cursor definitions
├── generate-cursors.py  # Regeneration script
└── README.md         # This file
```

## 🔧 Installation

### Method 1: Windows Settings (Easiest)

1. **Download** the cursors you want from `cur/` folder
2. **Right-click** on desktop → **Personalize**
3. **Click** on **Cursors** in the left sidebar
4. **Select** a cursor scheme → **Browse**
5. **Navigate** to the cursor file → **Open**
6. **Apply** and **Save**

### Method 2: Manual Installation

1. **Copy** cursor files to:
   ```
   C:\Windows\Cursors\
   ```
   Or any folder you prefer.

2. **Open** Control Panel → **Mouse** → **Pointers**

3. **Select** each cursor type and **Browse** to your cursor file

4. **Apply** and **OK**

### Method 3: Registry Installation

Create a `.reg` file with your cursor paths:

```reg
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Cursors]
"Arrow"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\normal.cur"
"AppStarting"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\busy.cur"
"Hand"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\hand.cur"
"Help"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\normal.cur"
"IBeam"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\text.cur"
"No"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\normal.cur"
"NWPen"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\precision.cur"
"SizeAll"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\move.cur"
"SizeNESW"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\resize-diagonal.cur"
"SizeNS"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\resize.cur"
"SizeNWSE"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\resize-diagonal.cur"
"SizeWE"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\resize-horizontal.cur"
"Wait"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\loading.cur"
"Crosshair"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\precision.cur"
"Link"="C:\\\\Windows\\\\Cursors\\\\LinkUp\\\\link.cur"
```

Double-click the `.reg` file to apply.

## 🎯 Usage in Web Projects

### CSS Method

1. Include the CSS file:
```html
<link rel="stylesheet" href="cursors/css/cursors.css">
```

2. Add cursor classes to elements:
```html
<div class="cursor-normal">Normal pointer</div>
<div class="cursor-text">Text selection</div>
<div class="cursor-busy">Loading state</div>
```

### CSS Custom Properties

```css
.my-button {
  cursor: url('../png/32/normal.png') 4 2, pointer;
}

.my-text-input {
  cursor: url('../png/32/text.png') 15 14, text;
}
```

### JavaScript Dynamic Cursors

```javascript
element.style.cursor = "url('../png/32/normal.png') 4 2, pointer";
```

## 📐 Cursor Sizes

| Size | Use Case |
|------|----------|
| 16px | Toolbar icons, small UI |
| 24px | Compact menus |
| 32px | **Default** - Windows standard |
| 48px | Large icons |
| 64px | High DPI displays |
| 96px | Presentation/demo |
| 128px | Large displays |

## 🎨 Design Features

### Style: GitHub Dark + Apple + Linear

- **Clean lines** - Minimal, precise edges
- **Dark palette** - GitHub dark theme colors
- **Subtle shadows** - Depth without distraction
- **High contrast** - Visible on any background
- **Consistent stroke** - Unified visual language

### Color Palette

| Element | Color |
|---------|-------|
| Primary | `#e6edf3` (Light) |
| Background | `#161b22` (Dark) |
| Border | `#30363d` (Gray) |
| Accent | `#58a6ff` (Blue) |

## 🔄 Regenerate Cursors

If you modify the SVG source files:

```bash
cd cursors
pip install Pillow cairosvg
python generate-cursors.py
```

## 🖼️ Preview

Open `preview.html` in a browser to see all cursors in action.

## 💡 Tips

### For Best Results

1. **Match cursor size to display DPI** - Higher DPI = larger cursors
2. **Test on multiple backgrounds** - Ensure visibility
3. **Keep hotpots accurate** - Point where users expect
4. **Use consistent style** - Mix with system cursors carefully

### Recommended Size Combinations

**Windows 10/11 (Standard):**
- Normal: 32px
- Text: 32px
- Resize: 32px

**High DPI (4K displays):**
- Normal: 48px
- Text: 48px
- Resize: 48px

**Touch/tablet:**
- Normal: 64px
- Text: 64px
- Resize: 64px

## 📄 License

Cursor pack created for LinkUp Studio. Free for personal and commercial use.

---

**Part of LinkUp Studio - Premium Windows Developer Environment**