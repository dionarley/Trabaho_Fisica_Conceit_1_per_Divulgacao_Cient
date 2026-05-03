#!/bin/bash
# Setup git hooks for the project
# Usage: ./scripts/setup-hooks.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setting up Git Hooks"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if .git exists
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo "✗ Not a git repository!"
    exit 1
fi

# Create post-tag hook
echo "Creating post-tag hook..."
cat > "$HOOKS_DIR/post-tag" << 'EOF'
#!/bin/bash
# Post-tag hook: runs after a tag is created

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Post-Tag Hook: Updating LICENSE and Credits"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run the update script
if [ -x "$SCRIPT_DIR/update-license-credits.sh" ]; then
    bash "$SCRIPT_DIR/update-license-credits.sh"
    
    # Auto-commit the changes
    cd "$SCRIPT_DIR/.."
    if ! git diff --quiet LICENSE docs/curiosidades.md 2>/dev/null; then
        git add LICENSE docs/curiosidades.md
        TAG_NAME=$(git describe --tags --exact-match 2>/dev/null || echo "latest")
        git commit -m "Update: LICENSE and credits for tag $TAG_NAME"
        echo ""
        echo "✓ Changes committed for tag $TAG_NAME"
    fi
else
    echo "⚠️  update-license-credits.sh not found in scripts/"
fi
EOF

chmod +x "$HOOKS_DIR/post-tag"
echo "✓ post-tag hook installed"

# Create pre-commit hook to sync dates
echo "Creating pre-commit hook for date sync..."
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash
# Pre-commit hook: sync dates before commit

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../scripts" && pwd)"

if [ -x "$SCRIPT_DIR/update-dates.sh" ]; then
    bash "$SCRIPT_DIR/update-dates.sh" 2>/dev/null
fi
EOF

chmod +x "$HOOKS_DIR/pre-commit"
echo "✓ pre-commit hook installed (date sync)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Hooks installed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Now when you create a tag, LICENSE and credits will be auto-updated."
echo "Example: git tag -a v1.4.0 -m 'New version' && git push origin --tags"
