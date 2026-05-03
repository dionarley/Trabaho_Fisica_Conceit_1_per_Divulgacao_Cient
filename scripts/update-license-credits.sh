#!/bin/bash
# Update LICENSE and curiosidades on tag/release
# Usage: ./scripts/update-license-credits.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Updating LICENSE and Credits"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get current year and version
YEAR=$(date +%Y)
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v1.3.0")
COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "60+")

echo "Year: $YEAR"
echo "Last tag: $LAST_TAG"
echo "Total commits: $COMMITS"
echo ""

# Update LICENSE file with current members
echo "Updating LICENSE..."
cat > LICENSE << EOF
CC BY-NC-SA 4.0
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International

Authors (${YEAR}):
- Amanda
- Sara  
- Bernado
- Miguel
- Andre
- Dionarley

You are free to:
Share — copy and redistribute the material in any medium or format
Adapt — remix, transform, and build upon the material

Under the following terms:
Attribution — You must give appropriate credit, provide a link to the license, 
  and indicate if changes were made. You may do so in any reasonable manner, 
  but not in any way that suggests the licensor endorses you or your use.
NonCommercial — You may not use the material for commercial purposes.
ShareAlike — If you remix, transform, or build upon the material, 
  you must distribute your contributions under the same license as the original.

No additional restrictions — You may not apply legal terms or technological 
  measures that legally restrict others from doing anything the license permits.

https://creativecommons.org/licenses/by-nc-sa/4.0/
https://creativecommons.org
EOF
echo "✓ LICENSE updated with all 6 members"

# Update curiosidades.md contributors table
echo "Updating curiosidades.md..."
if [ -f "docs/curiosidades.md" ]; then
    # Update contributors table (lines ~59-68)
    sed -i '/### Contribuidores:/,/!\[! tip/c\
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
    echo "✓ curiosidades.md contributors updated"
else
    echo "⊙ curiosidades.md not found, skipping"
fi

# Update commit count in curiosidades.md stats
echo "Updating commit count in curiosidades.md..."
if [ -f "docs/curiosidades.md" ]; then
    sed -i "s/| \*\*Total de commits\*\* | [0-9]\+/| **Total de commits** | $COMMITS |/" docs/curiosidades.md
    echo "✓ Commit count updated to $COMMITS"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Files updated:"
echo "  ✓ LICENSE - authors + year"
echo "  ✓ docs/curiosidades.md - contributors + commits"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next: git add LICENSE docs/curiosidades.md && git commit -m 'Update: LICENSE and credits for $LAST_TAG'"
