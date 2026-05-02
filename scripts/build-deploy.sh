#!/bin/bash
# Build and deploy MkDocs site with PDF generation
# Usage: ./scripts/build-deploy.sh [--no-pdf] [--skip-deploy]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Isaac Newton - Build & Deploy Script"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse arguments
GENERATE_PDF=true
DEPLOY=true

for arg in "$@"; do
    case $arg in
        --no-pdf)
            GENERATE_PDF=false
            shift
            ;;
        --skip-deploy)
            DEPLOY=false
            shift
            ;;
    esac
done

# Step 1: Install dependencies
echo "[1/4] Checking/installing dependencies..."
if [ "$GENERATE_PDF" = true ]; then
    pip install -q -r requirements.txt
else
    pip install -q mkdocs mkdocs-material
fi
echo "✓ Dependencies ready"
echo ""

# Step 2: Build site
echo "[2/4] Building MkDocs site..."
if [ "$GENERATE_PDF" = true ]; then
    echo "  (PDF generation enabled via ENABLE_PDF_EXPORT=1)"
    ENABLE_PDF_EXPORT=1 mkdocs build
else
    mkdocs build
fi
echo "✓ Site built successfully"
echo ""

# Step 3: Verify PDF
if [ "$GENERATE_PDF" = true ]; then
    echo "[3/4] Verifying PDF..."
    if [ -f "site/documento-isaac-newton.pdf" ]; then
        PDF_SIZE=$(du -h site/documento-isaac-newton.pdf | cut -f1)
        echo "✓ PDF generated: site/documento-isaac-newton.pdf ($PDF_SIZE)"
    else
        echo "⚠ Warning: PDF not found!"
    fi
    echo ""
fi

# Step 4: Deploy
if [ "$DEPLOY" = true ]; then
    echo "[4/4] Deploying to GitHub Pages..."
    if [ "$GENERATE_PDF" = true ]; then
        ENABLE_PDF_EXPORT=1 mkdocs gh-deploy --force
    else
        mkdocs gh-deploy --force
    fi
    echo ""
    echo "✓ Deployed to GitHub Pages!"
    echo "  URL: https://dionarley.github.io/Trabaho_Fisica_Conceit_1_per_Divulgacao_Cient/"
else
    echo "[4/4] Skipping deployment (--skip-deploy flag used)"
    echo "  Site is ready at: site/"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Build complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
