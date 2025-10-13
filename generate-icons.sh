#!/bin/bash

# Four-M Logo Icon Generator
# Generates vector-based icons in multiple sizes and formats

set -e

# Configuration
STROKE_WIDTH=6
SPACING=8
BG_COLOR="white"
FG_COLOR="black"

# Create output directory
mkdir -p assets/images/icons

# Generate the SVG content based on the React component
generate_svg() {
    local size=$1
    local filename=$2
    
    # Calculate geometry (from the React component logic)
    local s=$SPACING
    local points="${s},$((100 - s)) ${s},${s} 50,$((100 - s)) $((100 - s)),${s} $((100 - s)),$((100 - s))"
    local apexY=$((100 - s))
    
    # Calculate max distance from pivot
    local rMax=0
    local pts=("$s,$((100-s))" "$s,$s" "50,$((100-s))" "$((100-s)),$s" "$((100-s)),$((100-s))")
    local px=50
    local py=$((100-s))
    
    for pt in "${pts[@]}"; do
        IFS=',' read -r x y <<< "$pt"
        local dx=$((x - px))
        local dy=$((y - py))
        local d=$(echo "sqrt($dx*$dx + $dy*$dy)" | bc -l)
        if (( $(echo "$d > $rMax" | bc -l) )); then
            rMax=$d
        fi
    done
    
    # Fit scale
    local margin=$(echo "scale=2; $STROKE_WIDTH / 4" | bc -l)
    local radiusLimit=$(echo "scale=2; 50 - $margin" | bc -l)
    local fitScale=$(echo "scale=6; $radiusLimit / $rMax" | bc -l)
    
    # Center shift
    local centerShift=$((50 - apexY))
    
    cat > "$filename" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="$size" height="$size">
  <defs>
    <symbol id="m-shape-$size" viewBox="0 0 100 100">
      <polyline points="$points" fill="none" stroke="$FG_COLOR" stroke-width="$STROKE_WIDTH" stroke-linecap="round" stroke-linejoin="round"/>
    </symbol>
  </defs>
  <rect width="100%" height="100%" fill="$BG_COLOR"/>
  <g transform="translate(0 $centerShift) translate(50 $apexY) scale($fitScale) translate(-50 -$apexY)">
    <use href="#m-shape-$size"/>
    <g transform="rotate(90 50 $apexY)"><use href="#m-shape-$size"/></g>
    <g transform="rotate(180 50 $apexY)"><use href="#m-shape-$size"/></g>
    <g transform="rotate(270 50 $apexY)"><use href="#m-shape-$size"/></g>
  </g>
</svg>
EOF
}

echo "🎨 Generating Four-M Logo icons..."

# Generate SVG icons in different sizes (vector-based)
echo "📐 Creating SVG icons..."
generate_svg 16 "assets/images/icons/favicon-16.svg"
generate_svg 32 "assets/images/icons/favicon-32.svg"
generate_svg 48 "assets/images/icons/favicon-48.svg"
generate_svg 64 "assets/images/icons/favicon-64.svg"
generate_svg 96 "assets/images/icons/favicon-96.svg"
generate_svg 128 "assets/images/icons/favicon-128.svg"
generate_svg 180 "assets/images/icons/apple-touch-icon.svg"
generate_svg 192 "assets/images/icons/android-chrome-192.svg"
generate_svg 512 "assets/images/icons/android-chrome-512.svg"

# Check if ImageMagick is available for raster conversions
if command -v convert &> /dev/null; then
    echo "🖼️  Converting to PNG formats..."
    
    # Convert SVGs to PNG (for fallbacks)
    convert "assets/images/icons/favicon-32.svg" "assets/images/icons/favicon-32.png"
    convert "assets/images/icons/favicon-48.svg" "assets/images/icons/favicon-48.png"
    convert "assets/images/icons/favicon-64.svg" "assets/images/icons/favicon-64.png"
    
    # Create ICO file from multiple PNG sizes
    echo "🎯 Creating ICO file..."
    convert "assets/images/icons/favicon-16.svg" "assets/images/icons/favicon-32.svg" "assets/images/icons/favicon-48.svg" "assets/images/icons/favicon-64.svg" "assets/images/icons/favicon.ico"
    
    # Apple touch icon
    convert "assets/images/icons/apple-touch-icon.svg" "assets/images/icons/apple-touch-icon.png"
    
    # Android icons
    convert "assets/images/icons/android-chrome-192.svg" "assets/images/icons/android-chrome-192.png"
    convert "assets/images/icons/android-chrome-512.svg" "assets/images/icons/android-chrome-512.png"
    
    echo "✅ PNG and ICO files generated!"
else
    echo "⚠️  ImageMagick not found. Only SVG files generated."
    echo "   Install ImageMagick for PNG/ICO conversion: brew install imagemagick"
fi

# Check if Inkscape is available for additional vector formats
if command -v inkscape &> /dev/null; then
    echo "🎨 Converting to additional vector formats..."
    
    # Convert to EPS (vector)
    inkscape "assets/images/icons/favicon-64.svg" --export-type=eps --export-filename="assets/images/icons/favicon.eps"
    
    # Convert to PDF (vector)
    inkscape "assets/images/icons/favicon-64.svg" --export-type=pdf --export-filename="assets/images/icons/favicon.pdf"
    
    echo "✅ Additional vector formats generated!"
else
    echo "⚠️  Inkscape not found. Only SVG files generated."
    echo "   Install Inkscape for EPS/PDF conversion: brew install --cask inkscape"
fi

# Generate web app manifest
echo "📱 Creating web app manifest..."
cat > "assets/images/icons/site.webmanifest" << EOF
{
    "name": "Rooster",
    "short_name": "Rooster",
    "icons": [
        {
            "src": "android-chrome-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "android-chrome-512.png",
            "sizes": "512x512",
            "type": "image/png"
        }
    ],
    "theme_color": "#8B2A9B",
    "background_color": "#ffffff",
    "display": "standalone"
}
EOF

# Create a master SVG for general use
generate_svg 200 "assets/images/icons/rooster-logo.svg"

echo ""
echo "🎉 Icon generation complete!"
echo ""
echo "Generated files:"
echo "📁 assets/images/icons/"
echo "   🎯 favicon.ico (multi-size ICO)"
echo "   📱 apple-touch-icon.png"
echo "   🤖 android-chrome-*.png"
echo "   🎨 *.svg (vector formats)"
echo "   📄 favicon.eps (vector)"
echo "   📄 favicon.pdf (vector)"
echo "   📋 site.webmanifest"
echo ""
echo "💡 Tip: Add these to your HTML head:"
echo "   <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/images/icons/favicon-32.svg\">"
echo "   <link rel=\"icon\" type=\"image/x-icon\" href=\"/assets/images/icons/favicon.ico\">"
echo "   <link rel=\"apple-touch-icon\" href=\"/assets/images/icons/apple-touch-icon.png\">"
