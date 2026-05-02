#!/bin/bash
# Generate PDF documentation
# Usage: ./scripts/generate-pdf.sh [--open] [--serve]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Isaac Newton - PDF Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse arguments
OPEN_PDF=false
SERVE_MODE=false

for arg in "$@"; do
    case $arg in
        --open)
            OPEN_PDF=true
            shift
            ;;
        --serve)
            SERVE_MODE=true
            shift
            ;;
    esac
done

# Step 1: Check dependencies
echo "[1/4] Checking dependencies..."
if ! command -v mkdocs &> /dev/null; then
    echo "✗ mkdocs not found! Installing..."
    pip install -q mkdocs mkdocs-material mkdocs-with-pdf==0.9.3
else
    echo "✓ mkdocs is available"
fi
echo ""

# Step 2: Clean previous build
echo "[2/4] Cleaning previous build..."
rm -rf site/
echo "✓ Cleaned site/ directory"
echo ""

# Step 3: Generate PDF
echo "[3/4] Generating PDF (this may take a while)..."
echo "  Running: ENABLE_PDF_EXPORT=1 mkdocs build"
echo ""

START_TIME=$(date +%s)

ENABLE_PDF_EXPORT=1 mkdocs build 2>&1 | grep -E "(INFO|WARNING|ERROR|Converting|Documentation built)" || true

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "✓ Build completed in ${ELAPSED}s"
echo ""

# Step 4: Verify PDF
echo "[4/4] Verifying PDF..."
PDF_FILE="site/documento-isaac-newton.pdf"

if [ -f "$PDF_FILE" ]; then
    PDF_SIZE=$(du -h "$PDF_FILE" | cut -f1)
    PDF_PAGES=$(pdfinfo "$PDF_FILE" 2>/dev/null | grep "^Pages:" | awk '{print $2}' || echo "unknown")
    
    echo "✓ PDF generated successfully!"
    echo "  File: $PDF_FILE"
    echo "  Size: $PDF_SIZE"
    echo "  Pages: $PDF_PAGES"
    echo ""
    
    # Open PDF if requested
    if [ "$OPEN_PDF" = true ]; then
        echo "Opening PDF..."
        if command -v xdg-open &> /dev/null; then
            xdg-open "$PDF_FILE" &
        elif command -v open &> /dev/null; then
            open "$PDF_FILE"
        else
            echo "⚠ Cannot auto-open PDF. File is at: $PDF_FILE"
        fi
    fi
    
    # Serve mode
    if [ "$SERVE_MODE" = true ]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "  Serving site locally..."
        echo "  Access at: http://localhost:8000"
        echo "  PDF at: http://localhost:8000/documento-isaac-newton.pdf"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        mkdocs serve
    fi
    
else
    echo "✗ PDF generation failed!"
    echo "  Check the output above for errors."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  PDF Generation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
