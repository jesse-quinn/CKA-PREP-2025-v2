#!/bin/bash
# Validation script for Question 6 - CRDs (cert-manager)
set -uo pipefail

PASS=0
FAIL=0
TOTAL=0

check() {
  local description="$1"
  shift
  TOTAL=$((TOTAL + 1))
  if "$@" >/dev/null 2>&1; then
    echo "  PASS: $description"
    PASS=$((PASS + 1))
  else
    echo "  FAIL: $description"
    FAIL=$((FAIL + 1))
  fi
}

echo "======================================"
echo " Validating Question 6: CRDs"
echo "======================================"

# 1. ~/resources.yaml exists and is not empty
check "File ~/resources.yaml exists" \
  test -f "$HOME/resources.yaml"

check "File ~/resources.yaml is not empty" \
  test -s "$HOME/resources.yaml"

# 2. ~/resources.yaml contains cert-manager CRDs
check "File ~/resources.yaml lists cert-manager CRDs" \
  bash -c 'grep -qi "cert-manager" "$HOME/resources.yaml"'

# 3. ~/subject.yaml exists and is not empty
check "File ~/subject.yaml exists" \
  test -f "$HOME/subject.yaml"

check "File ~/subject.yaml is not empty" \
  test -s "$HOME/subject.yaml"

# 4. ~/subject.yaml contains subject-related documentation
check "File ~/subject.yaml contains subject specification info" \
  bash -c 'grep -qi "subject\|organization\|country\|province\|locality" "$HOME/subject.yaml"'

echo ""
echo "Results: $PASS/$TOTAL passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && echo "All checks passed!" || echo "Some checks failed."
exit $FAIL
