#!/bin/bash
# Cleanup script for Question 15 - Etcd Fix
set -uo pipefail
echo "Cleaning up Question 15: Etcd Fix..."

MANIFEST=/etc/kubernetes/manifests/kube-apiserver.yaml
BACKUP=/root/kube-apiserver.yaml.bak

# Restore only if the lab's breakage is still present, so a fixed (or never broken)
# manifest is left exactly as it is.
if sudo grep -q -- '--etcd-servers=.*:2380' "$MANIFEST" 2>/dev/null; then
  if sudo test -f "$BACKUP"; then
    sudo cp "$BACKUP" "$MANIFEST"
    echo "Restored $MANIFEST from $BACKUP; kubelet will recreate the apiserver pod."
  else
    echo "WARNING: $MANIFEST still points etcd at :2380 and no backup exists at $BACKUP."
    echo "Fix it by hand: change :2380 back to :2379 in --etcd-servers."
    exit 1
  fi
else
  echo "Manifest is not using :2380; nothing to restore."
fi

echo "To re-practice, re-run: scripts/run-question.sh 15"
echo "[OK] Question 15 cleanup complete"
