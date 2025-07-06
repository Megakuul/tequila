# Tequila 🌵

Argocd monorepo that deploys my homelab cluster called `tequila`.

## Preboot

Certain components of tequila are manually managed via Helm to solve chicken-egg-problems or handle secrets.

**argocd**:

```bash 
helm repo add argocd https://argoproj.github.io/argo-helm

helm install argo-cd argocd/argo-cd -f ./preboot/argocd/values.yaml \
  --namespace argocd \
  --create-namespace
```

**linkerd-certs**:

Generate required certificates as described [here](https://linkerd.io/2-edge/tasks/generate-certificates)
and apply them to the linkerd namespace.

```bash
helm install linkerd-certs ./preboot/linkerd-certs \
  --namespace linkerd \
  --create-namespace \
  --set-file ca_crt=./ca.crt \
  --set-file issuer_crt=./issuer.crt \
  --set-file issuer_key=./issuer.key
```
