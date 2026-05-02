#!/bin/bash
# Backup project to ZIP file
# Usage: ./scripts/backup.sh [backup-name]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Backup name
BACKUP_NAME=${1:-"backup-$(date +%Y%m%d-%H%M%S)"}
BACKUP_DIR="$PROJECT_ROOT/backups"
BACKUP_FILE="$BACKUP_DIR/${BACKUP_NAME}.zip"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Isaac Newton - Project Backup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Backup name: $BACKUP_NAME"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create ZIP excluding unnecessary files
echo "Creating backup..."
zip -r "$BACKUP_FILE" . \
    -x "*.git*" \
    -x "*/site/*" \
    -x "*/__pycache__/*" \
    -x "*.pyc" \
    -x "*/backups/*" \
    -x "*.DS_Store" \
    -x "*/.mise/*"

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

echo ""
echo "✓ Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
echo ""

# List recent backups
echo "Recent backups:"
ls -lht "$BACKUP_DIR" | head -6
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Backup complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
