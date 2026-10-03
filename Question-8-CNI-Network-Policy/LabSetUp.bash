#!/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/../scripts/lib.sh"

# This lab expects a cluster whose CNI it can remove and replace (Killercoda ships
# Cilium). On a cluster already running manifest-installed Calico, the operator
# install in the solution and the operator-manifest delete in cleanup both break
# pod networking, so refuse unless explicitly overridden.
if cka_has_manifest_calico && [[ "${CKA_ALLOW_CNI_REINSTALL:-0}" != "1" ]]; then
  echo "Refusing to run: Calico is already installed from manifest (kube-system/calico-node)."
  echo "Installing tigera-operator over it can break pod networking on this cluster."
  echo "Read Questions.bash and SolutionNotes.bash as a study exercise instead, or set"
  echo "CKA_ALLOW_CNI_REINSTALL=1 on a disposable cluster."
  exit 1
fi

WORKER="$(cka_target_node)"
# Remove the preinstalled Cilium CNI so Calico can be installed cleanly
kubectl delete daemonset cilium -n kube-system --ignore-not-found 2>/dev/null || true
kubectl delete daemonset cilium-envoy -n kube-system --ignore-not-found 2>/dev/null || true
kubectl delete serviceaccount cilium -n kube-system --ignore-not-found 2>/dev/null || true
kubectl delete clusterrole cilium --ignore-not-found 2>/dev/null || true
kubectl delete clusterrolebinding cilium --ignore-not-found 2>/dev/null || true
kubectl delete configmap cilium-config -n kube-system --ignore-not-found 2>/dev/null || true
kubectl delete namespace cilium --ignore-not-found 2>/dev/null || true

# Remove stale Cilium CNI config files from the nodes
sudo rm -f /etc/cni/net.d/*cilium*
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$WORKER" 'sudo rm -f /etc/cni/net.d/*cilium*'

echo "# Remove stale Cilium and Calico VXLAN interfaces from the nodes"
sudo ip link delete vxlan.calico 2>/dev/null || true
sudo ip link delete cilium_vxlan 2>/dev/null || true
sudo ip link delete cilium_host 2>/dev/null || true
sudo ip link delete cilium_net 2>/dev/null || true
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$WORKER" 'sudo ip link delete vxlan.calico 2>/dev/null || true; sudo ip link delete cilium_vxlan 2>/dev/null || true; sudo ip link delete cilium_host 2>/dev/null || true; sudo ip link delete cilium_net 2>/dev/null || true'

kubectl rollout restart deployment coredns -n kube-system

echo "# Follow the Tigera Calico documentation for the operator and custom resources manifests"
