#!/bin/bash
# Update member info from CSV to docs and mkdocs.yml
# Usage: ./scripts/update-members.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Update Member Info from CSV"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CSV_FILE="planilhas/membros-grupo.csv"

if [ ! -f "$CSV_FILE" ]; then
    echo "✗ CSV file not found: $CSV_FILE"
    exit 1
fi

echo "Reading members from: $CSV_FILE"
echo ""

# Read CSV (skip header)
MEMBERS=()
while IFS=';' read -r nome ram email whatsapp semestre dias horario disponibilidade preferencias experiencia recursos confirma observacoes; do
    # Skip header
    [[ "$nome" == "Nome Completo" ]] && continue
    # Skip empty
    [ -z "$nome" ] && continue
    
    MEMBERS+=("$nome")
    echo "  • $nome"
done < "$CSV_FILE"

TOTAL_MEMBERS=${#MEMBERS[@]}
echo ""
echo "Total members: $TOTAL_MEMBERS"
echo ""

# Update mkdocs.yml author field
echo "Updating mkdocs.yml author field..."
AUTHORS=$(printf ", %s" "${MEMBERS[@]}")
AUTHORS=${AUTHORS:2}  # Remove leading comma

# Keep the "+1 membro" if there's a 6th member placeholder
if [[ "${MEMBERS[-1]}" == "?"* ]]; then
    AUTHORS="$AUTHORS (+1 membro)"
fi

# Update site_author in mkdocs.yml
sed -i "s/^site_author:.*/site_author: $AUTHORS/" mkdocs.yml
echo "✓ Updated mkdocs.yml"
echo ""

# Update README.md member table
echo "Updating README.md member table..."
# This is a simplified version - in production, use a proper template engine
echo "⚠ README.md member table needs manual update or use a template"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Update complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
