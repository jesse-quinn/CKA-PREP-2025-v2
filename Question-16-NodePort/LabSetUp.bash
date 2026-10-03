#!/bin/bash
set -e

# Step 1: Create namespace
kubectl create namespace relative || true

# Step 2: Create deployment
kubectl -n relative create deployment nodeport-deployment \
  --image=nginx --replicas=2 --dry-run=client -o yaml | kubectl apply -f -

# Step 3: Expose deployment via NodePort
echo "Deployment 'nodeport-deployment' created in namespace 'relative'."
echo "Task: expose it via NodePort using a Service."