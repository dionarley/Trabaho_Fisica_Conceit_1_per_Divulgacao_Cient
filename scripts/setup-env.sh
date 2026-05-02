#!/bin/bash
# Setup development environment
# Usage: ./scripts/setup-env.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Isaac Newton - Environment Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Python
echo "[1/4] Checking Python..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1)
    echo "✓ $PYTHON_VERSION"
else
    echo "✗ Python 3 not found! Please install Python 3.8+"
    exit 1
fi
echo ""

# Check Git
echo "[2/4] Checking Git..."
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    echo "✓ $GIT_VERSION"
else
    echo "✗ Git not found! Please install Git"
    exit 1
fi
echo ""

# Install Python dependencies
echo "[3/4] Installing Python dependencies..."
pip install -r requirements.txt
echo ""

# Create necessary directories
echo "[4/4] Creating directories..."
mkdir -p site
mkdir -p scripts
echo "✓ Directories ready"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup complete!"
echo ""
echo "  Next steps:"
echo "  • Run: mkdocs serve (to start local server)"
echo "  • Run: ./scripts/build-deploy.sh (to build & deploy)"
echo "  • Run: ./scripts/check-links.sh (to check URLs)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
