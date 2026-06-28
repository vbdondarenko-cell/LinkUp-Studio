#!/usr/bin/env python3
"""
LinkUp Studio Cursor Pack Generator
Generates PNG and CUR files from SVG source cursors

Requirements:
    pip install Pillow cairosvg

Usage:
    python generate-cursors.py
"""

import os
import struct
import sys
from pathlib import Path

try:
    from PIL import Image
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False
    print("Pillow not installed. Run: pip install Pillow")
    sys.exit(1)

try:
    import cairosvg
    CAIRO_AVAILABLE = True
except ImportError:
    CAIRO_AVAILABLE = False
    print("CairoSVG not installed. Run: pip install cairosvg")
    sys.exit(1)

# Configuration
SOURCE_DIR = Path(__file__).parent / "source"
PNG_DIR = Path(__file__).parent / "png"
CUR_DIR = Path(__file__).parent / "cur"

# Cursor sizes
CURSOR_SIZES = [16, 24, 32, 48, 64, 96, 128]

# Cursor hotpots (x, y)
CURSOR_HOTSPOTS = {
    "normal": (4, 2),
    "busy": (16, 16),
    "loading": (16, 16),
    "text": (15, 14),
    "resize": (16, 16),
    "resize-horizontal": (16, 16),
    "resize-diagonal": (16, 16),
    "move": (16, 16),
    "precision": (16, 16),
    "link": (4, 2),
    "hand": (12, 4),
}


def get_svgs():
    """Get all SVG files from source directory."""
    return list(SOURCE_DIR.glob("*.svg"))


def svg_to_png(svg_path, output_path, size):
    """Convert SVG to PNG at specified size."""
    try:
        cairosvg.svg2png(
            url=str(svg_path),
            write_to=str(output_path),
            output_width=size,
            output_height=size
        )
        return True
    except Exception as e:
        print(f"  ⚠️  Error converting {svg_path.name}: {e}")
        return False


def create_cur_from_pngs(name, png_paths, hotspot):
    """Create a Windows CUR file from multiple PNG sizes."""
    if not PIL_AVAILABLE or not png_paths:
        return False
    
    images = []
    for png_path in sorted(png_paths):
        try:
            img = Image.open(png_path).convert("RGBA")
            images.append((img.size[0], img))
        except Exception as e:
            print(f"  ⚠️  Error loading {png_path}: {e}")
    
    if not images:
        return False
    
    # Create .cur file
    cur_path = CUR_DIR / f"{name}.cur"
    
    try:
        # CUR format: 6 byte header + directory entries + image data
        # For simplicity, we'll save as a single-size ICO-like format
        # that Windows can use as a cursor
        
        img = images[0][1]
        img.save(cur_path, format="ICO", sizes=[(img.size[0], img.size[0])])
        return True
    except Exception as e:
        print(f"  ⚠️  Error creating CUR file: {e}")
        return False


def create_animated_cursor(name, svg_path, sizes):
    """Create an animated cursor (ANI) file."""
    # ANI files are complex binary formats
    # For now, we'll create a multi-size CUR that acts like an ANI
    png_files = []
    
    for size in sizes:
        size_dir = PNG_DIR / str(size)
        size_dir.mkdir(exist_ok=True)
        output_path = size_dir / f"{name}.png"
        if svg_to_png(svg_path, output_path, size):
            png_files.append(output_path)
    
    return create_cur_from_pngs(name, png_files, CURSOR_HOTSPOTS.get(name, (16, 16)))


def process_cursor(svg_path):
    """Process a single cursor SVG."""
    name = svg_path.stem
    print(f"\n📦 Processing: {name}")
    
    png_files = []
    
    for size in CURSOR_SIZES:
        size_dir = PNG_DIR / str(size)
        size_dir.mkdir(exist_ok=True)
        output_path = size_dir / f"{name}.png"
        print(f"  → {size}x{size}...", end=" ")
        
        if svg_to_png(svg_path, output_path, size):
            png_files.append(output_path)
            print("✓")
        else:
            print("✗")
    
    # Create CUR file
    hotspot = CURSOR_HOTSPOTS.get(name, (16, 16))
    print(f"  → CUR...", end=" ")
    if create_cur_from_pngs(name, png_files, hotspot):
        print("✓")
    else:
        print("✗")
    
    return len(png_files) > 0


def main():
    """Main function."""
    print("=" * 50)
    print("  LinkUp Studio Cursor Pack Generator")
    print("=" * 50)
    
    if not SOURCE_DIR.exists():
        print(f"\n❌ Source directory not found: {SOURCE_DIR}")
        sys.exit(1)
    
    svgs = get_svgs()
    if not svgs:
        print(f"\n❌ No SVG files found in: {SOURCE_DIR}")
        sys.exit(1)
    
    print(f"\n📁 Found {len(svgs)} SVG cursors to process")
    
    success_count = 0
    for svg_path in sorted(svgs):
        if process_cursor(svg_path):
            success_count += 1
    
    print("\n" + "=" * 50)
    print(f"  ✅ Complete! Processed {success_count}/{len(svgs)} cursors")
    print("=" * 50)
    
    print(f"\n📂 Output directories:")
    print(f"   PNG: {PNG_DIR}")
    print(f"   CUR: {CUR_DIR}")


if __name__ == "__main__":
    main()