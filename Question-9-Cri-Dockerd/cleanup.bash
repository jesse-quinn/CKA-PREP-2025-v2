#!/bin/bash
# Cleanup script for Question 9 - Cri-Dockerd
set -uo pipefail
echo "Cleaning up Question 9: cri-dockerd..."

# Without dpkg the lab never ran, and /etc/sysctl.d/kube.conf may be the host's own
# Kubernetes sysctl file, so leave the node untouched.
if ! command -v dpkg >/dev/null 2>&1; then
  echo "[OK] Question 9 cleanup skipped (no dpkg; lab not supported on this node)"
  exit 0
fi

sudo systemctl disable --now cri-docker.service 2>/dev/null || true
sudo dpkg -r cri-dockerd 2>/dev/null || true
sudo rm -f /etc/sysctl.d/kube.conf
sudo sysctl --system >/dev/null 2>&1 || true

echo "[OK] Question 9 cleanup complete"
