#!/bin/bash
# Cleanup script for Question 8 - CNI & Network Policy
set -uo pipefail
echo "Cleaning up Question 8: CNI & Network Policy..."

source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib.sh"

# The tigera-operator manifest bundles the crd.projectcalico.org CRDs, so deleting
# it on a cluster that runs manifest-installed Calico tears down pod networking.
if cka_has_manifest_calico; then
  echo "Calico is installed from manifest (kube-system/calico-node); leaving all Calico resources in place."
else
  kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml 2>/dev/null || true
  kubectl delete namespace tigera-operator --ignore-not-found
  kubectl delete namespace calico-system --ignore-not-found
fi

# Remove Flannel if installed
kubectl delete namespace kube-flannel --ignore-not-found

echo "[OK] Question 8 cleanup complete"
echo "NOTE: CNI removal may require a node restart to fully take effect."
