#!/bin/bash
# Update dates in docs to match last commit date
# Usage: ./scripts/update-dates.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Updating Page Dates to Match Commits"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

UPDATED=0
SKIPPED=0

for file in docs/*.md; do
    # Get last commit date for this file
    commit_date=$(git log -1 --format="%ad" --date=format:"%d/%m/%Y" -- "$file" 2>/dev/null || echo "03/05/2026")
    
    # Check if file has update date
    if grep -q "Última atualização:" "$file"; then
        # Extract current date
        current_date=$(grep "Última atualização:" "$file" | sed 's/.*Última atualização: //' | tr -d '*')
        
        if [ "$current_date" != "$commit_date" ]; then
            # Update the date (line 3, after title) - use | as delimiter
            sed -i "2s|.*Última atualização: .*|\*Última atualização: $commit_date\*|" "$file"
            echo "✓ Updated: $(basename "$file") → $commit_date (was: $current_date)"
            UPDATED=$((UPDATED + 1))
        else
            echo "  Skipped: $(basename "$file") (already $commit_date)"
            SKIPPED=$((SKIPPED + 1))
        fi
    else
        # Add date after first line (title)
        sed -i "1a\\\n*Última atualização: $commit_date*\n" "$file"
        echo "+ Added: $(basename "$file") → $commit_date"
        UPDATED=$((UPDATED + 1))
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Results:"
echo "  ✓ Updated: $UPDATED"
echo "  ⊙ Skipped: $SKIPPED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $UPDATED -gt 0 ]; then
    echo "Run: git add docs/ && git commit -m 'Update: datas de atualização das páginas'"
    exit 0
else
    echo "All dates are already in sync with commits."
    exit 0
fi
