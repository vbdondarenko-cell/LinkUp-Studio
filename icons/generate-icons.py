#!/usr/bin/env python3
"""
LinkUp Studio Icon Pack Generator
Generates PNG and ICO files from SVG source icons

Requirements:
    pip install Pillow cairosvg

Usage:
    python generate-icons.py
"""

import os
import subprocess
import sys
from pathlib import Path

# Try to import required libraries
try:
    from PIL import Image
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False
    print("Pillow not installed. Run: pip install Pillow")

try:
    import cairosvg
    CAIRO_AVAILABLE = True
except ImportError:
    CAIRO_AVAILABLE = False
    print("CairoSVG not installed. Run: pip install cairosvg")

# Configuration
SOURCE_DIR = Path(__file__).parent / "source"
PNG_DIR = Path(__file__).parent / "png"
ICO_DIR = Path(__file__).parent / "ico"
SVG_DIR = Path(__file__).parent / "svg"

# PNG sizes to generate
PNG_SIZES = [16, 24, 32, 48, 64, 128, 256]

# SVG sizes to export
SVG_SIZES = [128, 256]


def get_svgs():
    """Get all SVG files from source directory."""
    return list(SOURCE_DIR.glob("*.svg"))


def svg_to_png(svg_path, output_path, size):
    """Convert SVG to PNG at specified size."""
    if CAIRO_AVAILABLE:
        cairosvg.svg2png(
            url=str(svg_path),
            write_to=str(output_path),
            output_width=size,
            output_height=size
        )
        return True
    else:
        # Fallback: use Inkscape if available
        try:
            subprocess.run([
                "inkscape",
                str(svg_path),
                "-w", str(size),
                "-h", str(size),
                "-o", str(output_path)
            ], check=True, capture_output=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            print(f"  ⚠️  Cannot convert {svg_path.name} - install cairosvg or inkscape")
            return False


def create_ico(png_paths, ico_path):
    """Create ICO file from multiple PNG sizes."""
    if not PIL_AVAILABLE:
        print("  ⚠️  Cannot create ICO - Pillow not installed")
        return False
    
    images = []
    for png_path in sorted(png_paths):
        try:
            img = Image.open(png_path).convert("RGBA")
            images.append(img)
        except Exception as e:
            print(f"  ⚠️  Error loading {png_path}: {e}")
    
    if images:
        # Save as ICO (PIL supports ICO format)
        images[0].save(
            ico_path,
            format="ICO",
            sizes=[(img.size[0], img.size[0]) for img in images],
            append_images=images[1:]
        )
        return True
    return False


def copy_svg(svg_path, size):
    """Copy SVG to size-specific directory."""
    size_dir = SVG_DIR / str(size)
    size_dir.mkdir(exist_ok=True)
    
    output_path = size_dir / svg_path.name
    import shutil
    shutil.copy2(svg_path, output_path)
    return output_path


def process_icon(svg_path):
    """Process a single SVG icon."""
    icon_name = svg_path.stem
    print(f"\n📦 Processing: {icon_name}")
    
    # Generate PNG at each size
    png_files = []
    for size in PNG_SIZES:
        size_dir = PNG_DIR / str(size)
        size_dir.mkdir(exist_ok=True)
        
        output_path = size_dir / f"{icon_name}.png"
        print(f"  → {size}x{size}...", end=" ")
        
        if svg_to_png(svg_path, output_path, size):
            png_files.append(output_path)
            print("✓")
        else:
            print("✗")
    
    # Copy SVG to size directories
    for size in SVG_SIZES:
        copy_svg(svg_path, size)
        print(f"  → SVG/{size} ✓")
    
    # Create ICO file
    if png_files:
        ico_path = ICO_DIR / f"{icon_name}.ico"
        print(f"  → ICO...", end=" ")
        if create_ico(png_files, ico_path):
            print("✓")
        else:
            print("✗")
    
    return len(png_files) > 0


def main():
    """Main function."""
    print("=" * 50)
    print("  LinkUp Studio Icon Pack Generator")
    print("=" * 50)
    
    # Check for source directory
    if not SOURCE_DIR.exists():
        print(f"\n❌ Source directory not found: {SOURCE_DIR}")
        sys.exit(1)
    
    # Get SVG files
    svgs = get_svgs()
    if not svgs:
        print(f"\n❌ No SVG files found in: {SOURCE_DIR}")
        sys.exit(1)
    
    print(f"\n📁 Found {len(svgs)} SVG icons to process")
    
    # Process each icon
    success_count = 0
    for svg_path in sorted(svgs):
        if process_icon(svg_path):
            success_count += 1
    
    # Summary
    print("\n" + "=" * 50)
    print(f"  ✅ Complete! Processed {success_count}/{len(svgs)} icons")
    print("=" * 50)
    
    print(f"\n📂 Output directories:")
    print(f"   PNG: {PNG_DIR}")
    print(f"   SVG: {SVG_DIR}")
    print(f"   ICO: {ICO_DIR}")
    
    # Installation instructions
    print("\n💡 Installation:")
    print("   - PNG files: Use with image editing software")
    print("   - ICO files: Use for Windows shortcuts/executables")
    print("   - SVG files: Use as vector source for any size")


if __name__ == "__main__":
    main()