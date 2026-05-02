#!/bin/bash
# Test mkdocs local server
# Usage: ./scripts/test-mkdocs-serve.sh [--no-pdf]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Test MkDocs Local Server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Parse arguments
GENERATE_PDF=false
if [[ "$1" == "--pdf" ]]; then
    GENERATE_PDF=true
    shift
fi

# Step 1: Kill any existing mkdocs server
echo "[1/4] Checking for existing mkdocs processes..."
pkill -f "mkdocs serve" 2>/dev/null || true
sleep 1
echo "✓ Cleaned up existing processes"
echo ""

# Step 2: Start mkdocs serve in background
echo "[2/4] Starting mkdocs serve..."
if [ "$GENERATE_PDF" = true ]; then
    echo "  (PDF generation enabled)"
    ENABLE_PDF_EXPORT=1 mkdocs serve --dev-addr 127.0.0.1:8000 &
else
    mkdocs serve --dev-addr 127.0.0.1:8000 &
fi

MKDOC_PID=$!
echo "  Started with PID: $MKDOC_PID"

# Wait for server to start
echo "  Waiting for server to start..."
for i in {1..30}; do
    if curl -s http://127.0.0.1:8000 > /dev/null 2>&1; then
        echo "  ✓ Server is up!"
        break
    fi
    sleep 1
    if [ $i -eq 30 ]; then
        echo "  ✗ Server failed to start within 30 seconds"
        kill $MKDOC_PID 2>/dev/null || true
        exit 1
    fi
done
echo ""

# Step 3: Test if site is accessible
echo "[3/4] Testing site accessibility..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000)
if [[ "$HTTP_CODE" =~ ^(200|301|302)$ ]]; then
    echo "  ✓ Site is accessible (HTTP $HTTP_CODE)"
else
    echo "  ✗ Site returned HTTP $HTTP_CODE"
    kill $MKDOC_PID 2>/dev/null || true
    exit 1
fi
echo ""

# Step 4: Test PDF link (if enabled)
if [ "$GENERATE_PDF" = true ]; then
    echo "[4/4] Testing PDF availability..."
    sleep 5  # Give time for PDF generation
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8000/documento-isaac-newton.pdf)
    if [[ "$HTTP_CODE" =~ ^(200|301|302)$ ]]; then
        echo "  ✓ PDF is accessible (HTTP $HTTP_CODE)"
    else
        echo "  ⚠ PDF not found (HTTP $HTTP_CODE) - may need more time to generate"
    fi
else
    echo "[4/4] Skipping PDF test (use --pdf to enable)"
fi
echo ""

# Success
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓ MkDocs server is running!"
echo "  Access at: http://127.0.0.1:8000"
if [ "$GENERATE_PDF" = true ]; then
    echo "  PDF at: http://127.0.0.1:8000/documento-isaac-newton.pdf"
fi
echo ""
echo "  Press Ctrl+C to stop the server"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Wait for user to stop
wait $MKDOC_PID 2>/dev/null || true
