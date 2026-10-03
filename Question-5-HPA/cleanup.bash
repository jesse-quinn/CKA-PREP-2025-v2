#!/bin/bash
# Cleanup script for Question 5 - HPA
set -uo pipefail
echo "Cleaning up Question 5: HPA..."

kubectl delete hpa apache-server -n autoscale --ignore-not-found
kubectl delete deployment apache-deployment -n autoscale --ignore-not-found
kubectl delete service apache-deployment -n autoscale --ignore-not-found
kubectl delete namespace autoscale --ignore-not-found
# Remove metrics-server only if this lab installed it; a pre-existing one serves
# kubectl top and every other HPA on the cluster.
if [[ "$(kubectl -n kube-system get deployment metrics-server -o jsonpath='{.metadata.labels.cka-prep/installed-by}' 2>/dev/null)" == "question-5" ]]; then
  kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml --ignore-not-found
else
  echo "Leaving metrics-server in place (not installed by this lab)."
fi
rm -f ~/hpa.yaml

echo "[OK] Question 5 cleanup complete"
