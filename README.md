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
4. Unseal vault and enable oidc login via https://learn.hashicorp.com/tutorials/vault/oidc-auth?in=vault/auth-methods

5. Apply the root manifest to be synced by argo:
    - Adds `ClusterIssuer` and cloudflare credentials
    - app-of-apps for the applications to be deployed into the cluster



### Notes

- wildcard certificate-secret needs to be synced across different namespaces (on a regular basis, as the cert expires after 90 days)
