#!/bin/bash
# Check for broken URLs in markdown files
# Usage: ./scripts/check-links.sh [--fix]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Checking URLs in Markdown Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

FIX_MODE=false
if [[ "$1" == "--fix" ]]; then
    FIX_MODE=true
    echo "Mode: FIX (will suggest corrections)"
fi
echo ""

# Find all markdown files
MD_FILES=$(find docs/ -name "*.md" -type f)
TOTAL_FILES=$(echo "$MD_FILES" | wc -l)
BROKEN_COUNT=0

echo "Scanning $TOTAL_FILES markdown files..."
echo ""

for file in $MD_FILES; do
    echo "Checking: $file"
    
    # Extract URLs (http/https)
    URLS=$(grep -oE 'https?://[^)]+' "$file" 2>/dev/null || true)
    
    if [ -z "$URLS" ]; then
        echo "  ✓ No URLs found"
        continue
    fi
    
    while IFS= read -r url; do
        # Skip empty
        [ -z "$url" ] && continue
        
        # Check URL
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" 2>/dev/null || echo "000")
        
        if [[ "$HTTP_CODE" =~ ^(200|301|302|307|308)$ ]]; then
            echo "  ✓ $url"
        else
            echo "  ✗ BROKEN ($HTTP_CODE): $url"
            BROKEN_COUNT=$((BROKEN_COUNT + 1))
            
            if [ "$FIX_MODE" = true ]; then
                # Suggest fixes for known patterns
                if [[ "$url" =~ seu-usuario ]]; then
                    echo "    → Fix: Replace 'seu-usuario' with 'dionarley'"
                elif [[ "$url" =~ creativecommons\.org\.br ]]; then
                    echo "    → Fix: Replace with 'https://br.creativecommons.org/'"
                elif [[ "$url" =~ sheets\.google ]]; then
                    echo "    → Fix: Replace with 'https://docs.google.com/spreadsheets/'"
                fi
            fi
        fi
    done <<< "$URLS"
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $BROKEN_COUNT -eq 0 ]; then
    echo "  ✓ All URLs are working!"
else
    echo "  ✗ Found $BROKEN_COUNT broken URL(s)"
    echo "  Run with --fix to see suggestions"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
