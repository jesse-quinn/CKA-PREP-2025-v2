#!/bin/bash
set -e

MANIFEST=/etc/kubernetes/manifests/kube-apiserver.yaml
BACKUP=/root/kube-apiserver.yaml.bak

echo "This lab breaks kube-apiserver on THIS node ($(hostname -s)) until you fix it."
echo "On a cluster with several control planes the others keep serving, so kubectl may"
echo "keep working; inspect this node with crictl and the static pod manifest instead."

# Step 1: Backup current kube-apiserver manifest, but only while it is healthy, so a
# re-run never overwrites the good copy with the broken one.
if sudo grep -q -- '--etcd-servers=.*:2379' "$MANIFEST"; then
  sudo cp "$MANIFEST" "$BACKUP"
else
  echo "Manifest is not using :2379; keeping the existing backup at $BACKUP"
fi

# Step 2: Simulate migration issue - change etcd client port to peer port 2380
sudo sed -i 's/:2379/:2380/g' "$MANIFEST"

# Step 3: Show kube-apiserver pod status/logs
echo "Checking kube-apiserver container..."
KAPISERVER_ID=$(sudo crictl ps -a | grep kube-apiserver | awk '{print $1}' | head -n 1)
if [ -n "$KAPISERVER_ID" ]; then
    sudo crictl logs "$KAPISERVER_ID" | tail -n 10 || true
else
    echo "kube-apiserver pod not found yet"
fi

# Step 4: Verify that kubectl fails as API server is down
kubectl get nodes || echo "As expected, API server is down due to misconfigured etcd client port."
echo "Backup of the original manifest: $BACKUP (cleanup restores it if still broken)."
