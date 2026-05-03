#!/bin/bash
# Test all automation scripts
# Usage: ./scripts/test-all.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Testing Automation Scripts"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PASS=0
FAIL=0

test_passed() {
    echo "  ✓ $1"
    PASS=$((PASS + 1))
}

test_failed() {
    echo "  ✗ $1"
    FAIL=$((FAIL + 1))
}

# Test 1: Check scripts exist and are executable
echo "[1/7] Checking script files..."
SCRIPTS=(
    "scripts/build-deploy.sh"
    "scripts/check-links.sh"
    "scripts/validate-csv.sh"
    "scripts/update-members.sh"
    "scripts/setup-env.sh"
    "scripts/backup.sh"
    "scripts/generate-pdf.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        test_passed "$script exists and is executable"
    else
        test_failed "$script missing or not executable"
    fi
done
echo ""

# Test 2: Syntax check (bash -n)
echo "[2/7] Syntax checking scripts..."
for script in scripts/*.sh; do
    if bash -n "$script" 2>/dev/null; then
        test_passed "$(basename "$script") has valid syntax"
    else
        test_failed "$(basename "$script") has syntax errors"
    fi
done
echo ""

# Test 3: Test validate-csv.sh
echo "[3/7] Testing validate-csv.sh..."
if [ -f "planilhas/membros-grupo.csv" ]; then
    OUTPUT=$(bash scripts/validate-csv.sh 2>&1)
    if echo "$OUTPUT" | grep -q "All CSV files are valid"; then
        test_passed "validate-csv.sh works correctly"
    else
        test_failed "validate-csv.sh produced unexpected output"
        echo "  Output: $OUTPUT"
    fi
else
    test_failed "CSV files not found for testing"
fi
echo ""

# Test 4: Test check-links.sh (dry run - just check it runs)
echo "[4/7] Testing check-links.sh..."
OUTPUT=$(bash scripts/check-links.sh 2>&1)
if echo "$OUTPUT" | grep -q "Checking URLs"; then
    test_passed "check-links.sh runs successfully"
else
    test_failed "check-links.sh failed to run"
fi
echo ""

# Test 5: Test setup-env.sh (check it runs, don't actually install)
echo "[5/7] Testing setup-env.sh (simulated)..."
if bash -n scripts/setup-env.sh; then
    test_passed "setup-env.sh syntax is valid"
else
    test_failed "setup-env.sh has issues"
fi
echo ""

# Test 6: Test backup.sh (create a test backup)
echo "[6/7] Testing backup.sh..."
mkdir -p backups
TEST_BACKUP="test-backup-$(date +%s)"
if bash scripts/backup.sh "$TEST_BACKUP" 2>&1 | grep -q "Backup created"; then
    test_passed "backup.sh creates backups successfully"
    # Clean up test backup
    rm -f "backups/${TEST_BACKUP}.zip"
else
    test_failed "backup.sh failed"
fi
echo ""

# Test 7: Test generate-pdf.sh (syntax check only - don't generate)
echo "[7/8] Testing generate-pdf.sh (syntax)..."
if bash -n scripts/generate-pdf.sh; then
    test_passed "generate-pdf.sh has valid syntax"
else
    test_failed "generate-pdf.sh has syntax errors"
fi
echo ""

# Test 8: Verify PDF link in index.md
echo "[8/8] Testing PDF link in index.md..."
if grep -q "dionarley.github.io.*documento-isaac-newton.pdf" docs/index.md; then
    test_passed "PDF link in index.md is correct"
else
    test_failed "PDF link in index.md is missing or incorrect"
fi

# Test 8b: Verify PDF is accessible (if site is deployed)
PDF_URL=$(grep -oP 'https://dionarley\.github\.io[^)]*documento-isaac-newton\.pdf' docs/index.md | head -1)
if [ -n "$PDF_URL" ]; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$PDF_URL" 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "200" ]; then
        test_passed "PDF is accessible at $PDF_URL (HTTP $HTTP_CODE)"
    else
        test_failed "PDF returned HTTP $HTTP_CODE at $PDF_URL"
    fi
else
    test_failed "Could not extract PDF URL from index.md"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Test Results:"
echo "  ✓ Passed: $PASS"
echo "  ✗ Failed: $FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "✓ All tests passed! Ready to deploy."
    exit 0
else
    echo "✗ Some tests failed. Fix issues before deploying."
    exit 1
fi
