# PWA Icon Instructions

The application needs icon files in the following sizes:

- `icon-192.png` (192x192 pixels)
- `icon-512.png` (512x512 pixels)
- `icon.png` (any size, typically 512x512)

## Quick Generation Options:

### Option 1: Use an online tool
Visit https://www.pwabuilder.com/imageGenerator and upload your logo to generate all required sizes.

### Option 2: Use the SVG icon
The `icon.svg` file is already created. You can:
1. Open it in a browser
2. Right-click and save as PNG at different sizes
3. Or use an online SVG to PNG converter

### Option 3: Manual creation
Create square images with:
- Background color: #3b82f6 (blue)
- Letter "T" or your logo in white
- Export as PNG at 192x192 and 512x512

## Temporary Icons
For now, copy the icon.svg as placeholders:
```bash
# These are symbolic links - replace with actual PNG files later
ln -sf icon.svg icon-192.png
ln -sf icon.svg icon-512.png
ln -sf icon.svg icon.png
```

Note: Modern browsers support SVG for PWA icons, but PNG is recommended for better compatibility.
