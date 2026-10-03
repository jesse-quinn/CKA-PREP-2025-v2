# Step 1: create PVC. There are 2 ways to do this. (PV is pre-reset by LabSetUp.bash)
cat <<'EOF' > pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb
  namespace: mariadb
spec:
  accessModes:
  - ReadWriteOnce
  volumeName: mariadb-pv  # bind to specific PV. This is optional but ensures we know which PV is used. If left blank, PVC will bind to any available PV that matches access modes and storage class.
  resources:
    requests:
      storage: 250Mi
  storageClassName: # Set this to the default storage class name. Some are "standard" some "local-path" etc. Check with "kubectl get storageclass". 
                    # storageClassName must match the PV's class even when volumeName is set; volumeName
                    # picks the PV, it does not bypass the class check. Check with: kubectl get pv mariadb-pv
EOF
kubectl apply -f pvc.yaml
kubectl get pvc mariadb -n mariadb
kubectl get pv mariadb-pv     # should show Bound to mariadb

# Step 2: ensure deployment uses the PVC
# mariadb-deploy.yaml should mount claimName: mariadb
# (LabSetUp.bash leaves claimName blank for practice)
kubectl apply -f mariadb-deploy.yaml
kubectl get pods -n mariadb
