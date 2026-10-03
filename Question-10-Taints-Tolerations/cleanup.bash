#!/bin/bash
# Cleanup script for Question 10 - Taints & Tolerations
set -uo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib.sh"
echo "Cleaning up Question 10: Taints & Tolerations..."

# Remove taint from the target node
kubectl taint nodes "$(cka_target_node)" PERMISSION=granted:NoSchedule- 2>/dev/null || true

# Delete pods created for this question
kubectl delete pod nginx nginx-fail --ignore-not-found

echo "[OK] Question 10 cleanup complete"
