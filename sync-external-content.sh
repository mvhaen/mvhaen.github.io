#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMP_DIR="$ROOT_DIR/_temp-external"
SOURCE_DIR="$TEMP_DIR/insensitivity-entrenchment-agility"
INCLUDE_FILE="$ROOT_DIR/_includes/external-insensitivity-content.html"
LOCAL_IMAGE_DIR="$ROOT_DIR/assets/images/2025-01-26-insensitivity-entrenchment-agility"
PDF_DIR="$ROOT_DIR/assets/resources/2025-01-26-insensitivity-entrenchment-agility"
PDF_FILE="$PDF_DIR/why-organizations-become-rigid-and-what-actually-helps.pdf"
ARTICLE_TITLE="Why Organizations Become Rigid (and What Actually Helps)"
ARTICLE_SUBTITLE="A systems lens on rigidity, adaptation, and organizational design"
ARTICLE_AUTHOR="Michael Voorhaen"

cleanup() {
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

detect_chrome() {
  if [[ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]]; then
    echo "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  elif command -v google-chrome >/dev/null 2>&1; then
    command -v google-chrome
  elif command -v chromium >/dev/null 2>&1; then
    command -v chromium
  else
    echo "Chrome or Chromium is required to generate the PDF." >&2
    exit 1
  fi
}

generate_pdf() {
  local chrome_bin temp_md temp_html temp_css chrome_pid last_size current_size stable_checks timeout_seconds elapsed

  require_command pandoc
  chrome_bin="$(detect_chrome)"

  mkdir -p "$PDF_DIR"

  temp_md="$TEMP_DIR/article-for-pdf.md"
  temp_html="$TEMP_DIR/article-for-pdf.html"
  temp_css="$TEMP_DIR/article-for-pdf.css"

  cat > "$temp_md" <<EOF
<div class="pdf-subtitle">$ARTICLE_SUBTITLE</div>
<div class="pdf-author">$ARTICLE_AUTHOR</div>

EOF
  cat "$INCLUDE_FILE" >> "$temp_md"

  PDF_IMAGE_DIR="$LOCAL_IMAGE_DIR" perl -0pi -e '
    s!\]\(/assets/images/2025-01-26-insensitivity-entrenchment-agility/([^)]+)\)!](file://$ENV{PDF_IMAGE_DIR}/$1)!g;
    s!src="/assets/images/2025-01-26-insensitivity-entrenchment-agility/([^"]+)"!src="file://$ENV{PDF_IMAGE_DIR}/$1"!g;
  ' "$temp_md"

  cat > "$temp_css" <<'EOF'
@page {
  size: A4;
  margin: 18mm 16mm 18mm;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
  color: #111111;
  line-height: 1.6;
  max-width: 820px;
  margin: 0 auto;
  padding: 24px 8px 48px;
}

h1 {
  font-size: 32px;
  line-height: 1.2;
  margin: 0 0 8px;
}

h2 {
  font-size: 24px;
  line-height: 1.3;
  margin: 30px 0 12px;
}

h3 {
  font-size: 18px;
  line-height: 1.35;
  margin: 18px 0 8px;
}

p, li {
  font-size: 14px;
}

img {
  max-width: 100%;
  height: auto;
  display: block;
  margin: 18px auto;
}

img.blog-image--full-height {
  max-height: none !important;
  object-fit: contain !important;
}

.pdf-subtitle {
  font-size: 18px;
  font-style: italic;
  color: #555555;
  margin: 0 0 6px;
}

.pdf-author {
  font-size: 13px;
  color: #666666;
  margin: 0 0 24px;
}

figcaption, em {
  color: #666666;
}

code {
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
}

pre {
  white-space: pre-wrap;
}

@media print {
  body {
    max-width: none;
    padding: 0;
  }

  h2, h3, img {
    break-inside: avoid;
    page-break-inside: avoid;
  }
}
EOF

  pandoc \
    --standalone \
    --from=gfm+raw_html \
    --css "$temp_css" \
    --metadata title="$ARTICLE_TITLE" \
    --output "$temp_html" \
    "$temp_md"

  rm -f "$PDF_FILE"

  "$chrome_bin" \
    --headless=new \
    --disable-gpu \
    --allow-file-access-from-files \
    --no-first-run \
    --no-default-browser-check \
    --no-pdf-header-footer \
    --user-data-dir="$TEMP_DIR/chrome-profile" \
    --print-to-pdf="$PDF_FILE" \
    "file://$temp_html" >/dev/null 2>&1 &
  chrome_pid=$!

  last_size=0
  stable_checks=0
  timeout_seconds=60
  elapsed=0

  while (( elapsed < timeout_seconds )); do
    if [[ -s "$PDF_FILE" ]]; then
      current_size=$(stat -f%z "$PDF_FILE")
      if [[ "$current_size" -eq "$last_size" ]]; then
        stable_checks=$((stable_checks + 1))
      else
        stable_checks=0
        last_size="$current_size"
      fi

      if (( stable_checks >= 2 )); then
        break
      fi
    fi

    sleep 1
    elapsed=$((elapsed + 1))
  done

  if [[ ! -s "$PDF_FILE" ]]; then
    kill "$chrome_pid" >/dev/null 2>&1 || true
    wait "$chrome_pid" >/dev/null 2>&1 || true
    echo "PDF generation failed: $PDF_FILE was not created." >&2
    exit 1
  fi

  kill "$chrome_pid" >/dev/null 2>&1 || true
  wait "$chrome_pid" >/dev/null 2>&1 || true
}

cd "$ROOT_DIR"

echo "Syncing external content..."

echo "Cloning external repository..."
rm -rf "$TEMP_DIR"
git clone --depth 1 https://github.com/mvhaen/psychology-of-agility-papers.git "$TEMP_DIR"

echo "Copying content to _includes..."
tail -n +2 "$SOURCE_DIR/insensitivity-entrenchment-agility.md" > "$INCLUDE_FILE"

echo "Syncing images..."
mkdir -p "$LOCAL_IMAGE_DIR"

REFERENCED_FILE="$TEMP_DIR/referenced-assets.txt"
perl -nle 'while (/\]\(assets\/(?:diagrams\/)?([^)]+)\)/g) { print $1 }' \
  "$SOURCE_DIR/insensitivity-entrenchment-agility.md" | sort -u > "$REFERENCED_FILE"

find "$LOCAL_IMAGE_DIR" -maxdepth 1 -type f \
  \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' -o -name '*.svg' \) \
  | while IFS= read -r local_file; do
      if ! grep -Fxq "$(basename "$local_file")" "$REFERENCED_FILE"; then
        rm -f "$local_file"
      fi
    done

while IFS= read -r asset; do
  if [[ -f "$SOURCE_DIR/assets/$asset" ]]; then
    cp "$SOURCE_DIR/assets/$asset" "$LOCAL_IMAGE_DIR/$asset"
  elif [[ -f "$SOURCE_DIR/assets/diagrams/$asset" ]]; then
    cp "$SOURCE_DIR/assets/diagrams/$asset" "$LOCAL_IMAGE_DIR/$asset"
  else
    echo "Referenced asset not found in external repo: $asset" >&2
    exit 1
  fi
done < "$REFERENCED_FILE"

echo "Normalizing imported asset paths..."
perl -0pi -e 's!\]\(assets/(?:diagrams/)?([^)]+)\)!\](/assets/images/2025-01-26-insensitivity-entrenchment-agility/$1)!g' "$INCLUDE_FILE"

echo "Applying display overrides for large system diagrams..."
perl -0pi -e 's{!\[([^\]]+)\]\((/assets/images/2025-01-26-insensitivity-entrenchment-agility/(?:problem-model|lever-whole-product-ownership|lever-leadership)\.png)\)}{<img src="$2" alt="$1" class="blog-image--full-height" />}g' "$INCLUDE_FILE"

echo "Generating PDF..."
generate_pdf

echo "Content synced successfully!"
echo "Don't forget to commit and push the changes."
