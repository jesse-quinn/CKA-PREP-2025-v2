#!/bin/bash
# Shared helpers for question scripts that must work on Killercoda (controlplane +
# node01, run as root) and on self-managed multi-node kubeadm clusters.

# The node a node-scoped question targets. Killercoda names its worker node01;
# elsewhere fall back to the last node by name so the choice is stable across
# setup, validate, and cleanup. Override with CKA_NODE.
cka_target_node() {
  if [[ -n "${CKA_NODE:-}" ]]; then
    echo "$CKA_NODE"
    return 0
  fi
  if kubectl get node node01 >/dev/null 2>&1; then
    echo "node01"
    return 0
  fi
  kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | sort | tail -1
}

# Calico installed from the plain manifest runs calico-node in kube-system; the
# tigera-operator install runs it in calico-system. Deleting the operator manifest
# also deletes the crd.projectcalico.org CRDs a manifest install depends on.
cka_has_manifest_calico() {
  kubectl -n kube-system get daemonset calico-node >/dev/null 2>&1
}
