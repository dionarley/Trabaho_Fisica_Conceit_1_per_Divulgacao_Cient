#!/bin/bash
# Update curiosidades.md on tag/release
# Usage: ./scripts/update-curiosidades.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Updating curiosidades.md for Tag/Release"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get current info
YEAR=$(date +%Y)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.3.0")
COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "60+")

echo "Year: $YEAR"
echo "Last tag: $LAST_TAG"
echo "Total commits: $COMMITS"
echo ""

# Update curiosidades.md contributors table
echo "Updating curiosidades.md..."
if [ -f "docs/curiosidades.md" ]; then
    # Update contributors table (lines ~59-68)
    sed -i '/### Contribuidores:/,/!!! tip/c\
### Contribuidores:\
\
| Autor | Status |\
|--------|--------|\
| Amanda | Membro |\
| Sara | Membro |\
| Bernado | Membro |\
| Miguel | Membro |\
| Andre | Membro |\
| Dionarley | '"$COMMITS"' commits |\
\
!!! tip "Curiosidade"\
    Como o projeto é colaborativo, espera-se que outros membros do grupo também façam commits após configurarem o Git!' docs/curiosidades.md
    
    # Update commit count in stats
    sed -i "s/| \*\*Total de commits\*\* | [0-9]\+/| **Total de commits** | $COMMITS |/" docs/curiosidades.md
    
    echo "✓ curiosidades.md contributors + commits updated"
else
    echo "⚠️  curiosidades.md not found, skipping"
fi

# Sync dates
if [ -x "$SCRIPT_DIR/update-dates.sh" ]; then
    echo ""
    echo "Syncing dates..."
    bash "$SCRIPT_DIR/update-dates.sh" 2>/dev/null || true
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Files updated:"
echo "  ✓ docs/curiosidades.md - contributors + commits"
echo "  ✓ docs/curiosidades.md - dates synced"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next: git add docs/curiosidades.md && git commit -m 'Update: curiosidades for $LAST_TAG'"
