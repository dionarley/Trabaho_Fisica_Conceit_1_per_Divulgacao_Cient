#!/bin/bash
# Check for personal data leaks and security issues
# Usage: ./scripts/check-security.sh [--fix]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Security & Data Leak Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

FIX_MODE=false
if [[ "$1" == "--fix" ]]; then
    FIX_MODE=true
    echo "Mode: FIX (will suggest corrections)"
fi
echo ""

ISSUES_FOUND=0

# Issue 1: Check if personal data files are tracked by git
echo "[1/8] Checking for personal data in git tracking..."
PERSONAL_FILES=(
    "planilhas/membros-grupo.csv"
    "Documentos/membros.txt"
    "planilhas/*.ods"
)

for pattern in "${PERSONAL_FILES[@]}"; do
    if git ls-files --error-unmatch $pattern > /dev/null 2>&1; then
        echo "  ✗ Personal data tracked: $pattern"
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
        if [ "$FIX_MODE" = true ]; then
            echo "    → Run: git rm --cached $pattern"
            echo "    → Ensure it's in .gitignore"
        fi
    else
        echo "  ✓ $pattern not tracked"
    fi
done
echo ""

# Issue 2: Check .gitignore effectiveness
echo "[2/8] Verifying .gitignore patterns..."
if ! grep -q "planilhas/membros-grupo.csv" .gitignore; then
    echo "  ✗ membros-grupo.csv not in .gitignore"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo "  ✓ membros-grupo.csv ignored"
fi

if ! grep -q "Documentos/membros.txt" .gitignore; then
    echo "  ✗ membros.txt not in .gitignore"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo "  ✓ membros.txt ignored"
fi
echo ""

# Issue 3: Scan for potential phone numbers in docs
echo "[3/8] Scanning for phone numbers in documentation..."
PHONE_FOUND=false
while IFS= read -r -d '' file; do
    # Skip binary files and gitignore
    [[ "$file" == ".gitignore" ]] && continue
    [[ "$file" == *.png ]] && continue
    [[ "$file" == *.jpg ]] && continue
    [[ "$file" == *.pdf ]] && continue
    
    # Look for phone number patterns (Brazilian format)
    if grep -qE '($$?\d{2}$$?\s?)?\d{4,5}-?\d{4}' "$file" 2>/dev/null; then
        echo "  ⚠ Possible phone number in: $file"
        PHONE_FOUND=true
    fi
done < <(find docs/ -type f 2>/dev/null)
if [ "$PHONE_FOUND" = false ]; then
    echo "  ✓ No phone numbers found in docs/"
fi
echo ""

# Issue 4: Scan for email addresses in docs
echo "[4/8] Scanning for email addresses in documentation..."
EMAIL_FOUND=false
while IFS= read -r -d '' file; do
    [[ "$file" == ".gitignore" ]] && continue
    [[ "$file" == *.png ]] && continue
    [[ "$file" == *.jpg ]] && continue
    
    if grep -qE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$file" 2>/dev/null; then
        echo "  ⚠ Possible email in: $file"
        grep -nE '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' "$file" 2>/dev/null | head -3
        EMAIL_FOUND=true
    fi
done < <(find docs/ -type f 2>/dev/null)
if [ "$EMAIL_FOUND" = false ]; then
    echo "  ✓ No email addresses found in docs/"
fi
echo ""

# Issue 5: Check for large files that shouldn't be committed
echo "[5/8] Checking for large files (>5MB)..."
LARGE_FILES=$(find . -type f -size +5M ! -path './.git/*' ! -path './site/*' 2>/dev/null || true)
if [ -n "$LARGE_FILES" ]; then
    echo "  ⚠ Large files found:"
    echo "$LARGE_FILES" | while read -r file; do
        SIZE=$(du -h "$file" | cut -f1)
        echo "    $file ($SIZE)"
    done
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo "  ✓ No large files found"
fi
echo ""

# Issue 6: Check for API keys/secrets
echo "[6/8] Scanning for potential secrets/API keys..."
SECRET_PATTERNS=(
    "api[_-]?key"
    "secret"
    "password"
    "token"
    "ghp_[a-zA-Z0-9]{36}"  # GitHub personal access token
    "github_pat_[a-zA-Z0-9_]{82}"  # GitHub fine-grained PAT
)

SECRETS_FOUND=false
for pattern in "${SECRET_PATTERNS[@]}"; do
    if grep -rqiE "$pattern" docs/ 2>/dev/null; then
        echo "  ⚠ Possible secret found (pattern: $pattern)"
        SECRETS_FOUND=true
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
done
if [ "$SECRETS_FOUND" = false ]; then
    echo "  ✓ No obvious secrets found"
fi
echo ""

# Issue 7: Check file permissions
echo "[7/8] Checking file permissions..."
BAD_PERMS=$(find . -type f -perm 0777 ! -path './.git/*' 2>/dev/null || true)
if [ -n "$BAD_PERMS" ]; then
    echo "  ⚠ Files with 777 permissions:"
    echo "$BAD_PERMS"
    ISSUES_FOUND=$((ISSUES_FOUND + 1))
else
    echo "  ✓ No permission issues"
fi
echo ""

# Issue 8: Check for sensitive files in git history
echo "[8/8] Checking git history for sensitive files..."
SENSITIVE_IN_HISTORY=false
for file in "planilhas/membros-grupo.csv" "Documentos/membros.txt"; do
    if git log --all --pretty="" --name-only 2>/dev/null | grep -q "$file"; then
        echo "  ⚠ $file found in git history!"
        echo "    → Use: git filter-branch or BFG Repo-Cleaner to remove"
        SENSITIVE_IN_HISTORY=true
        ISSUES_FOUND=$((ISSUES_FOUND + 1))
    fi
done
if [ "$SENSITIVE_IN_HISTORY" = false ]; then
    echo "  ✓ No sensitive files in git history"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ISSUES_FOUND -eq 0 ]; then
    echo "  ✓ Security check passed! No issues found."
else
    echo "  ✗ Found $ISSUES_FOUND issue(s)"
    echo "  Run with --fix for suggestions"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
