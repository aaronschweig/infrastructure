# Setup

1. Create the cluster
2. Fill out the credentials in the value file and install the [argo helm chart](https://argoproj.github.io/argo-helm)
```bash
helm install argocd argoproj/argo-cd -n argocd --create-namespace -f argocd/values.yaml
```
3. Install the [cert-manager helm chart](https://charts.jetstack.io)
```bash
helm install cert-manager jetstack/cert-manager -n cert-manager --create-namespace --set installCRDs=true
```

4. Unseal vault and apply the `vault/post-start.sh` script
5. Seed the vault with the required secret values

5. Apply the root manifest for argocd to take over


### Notes

- wildcard certificate-secret needs to be synced across different namespaces (on a regular basis, as the cert expires after 90 days)
