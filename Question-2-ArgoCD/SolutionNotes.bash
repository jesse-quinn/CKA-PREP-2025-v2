# Create namespace
kubectl create namespace argocd

# Add repo and template manifests (CRDs not installed)
helm repo add argocd https://argoproj.github.io/argo-helm
helm repo update

# To get the crd value to change, you can run: helm show values argocd/argo-cd --version 7.7.3 | grep -i crd -C 4

# Optional: the task only asks for the template. Without the Argo CD CRDs already present
# the installed controllers will not start.
helm install argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd
helm template argocd argocd/argo-cd --version 7.7.3 --set crds.install=false --namespace argocd > ~/argo-helm.yaml
cat ~/argo-helm.yaml   # confirm output


#Additional helm tips:
# To list all versions of a chart: helm search repo argocd/argo-cd --versions
# To show values of a chart: helm show values argocd/argo-cd --version 7.7.3
