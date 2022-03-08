# Setup

1. Create the cluster
2. Install the [argo helm chart](https://argoproj.github.io/argo-helm)
```bash
helm install argocd argoproj/argo-cd -n argocd --create-namespace -f argocd/values.yaml
```
3. Install the [cert-manager helm chart](https://charts.jetstack.io)
```bash
helm install cert-manager jetstack/cert-manager -n cert-manager --create-namespace --set installCRDs=true
```
4. Apply the root manifest to be synced by argo:
    - Adds `ClusterIssuer` and cloudflare credentials
    - Adds vault
    - app-of-apps for the applications to be deployed into the cluster

5. Unseal vault and enable oidc login via https://learn.hashicorp.com/tutorials/vault/oidc-auth?in=vault/auth-methods


### Notes

- wildcard certificate-secret needs to be synced across different namespaces (on a regular basis, as the cert expires after 90 days)

# Adding important resources to the cluster

## ArgoCD

To enable a GitOps based workflow with easy deployments to the kubernetes cluster we use argocd. This autmagically generates a desired state out of a git repository and syncs it with the current state in the cluster.
This enabled an easy deployment workflow, with fine-grained controls.

To deploy ArgoCD we use their [helm chart](https://argoproj.github.io/argo-helm) with the overrides specified in the `argo/values.yaml` file. To expose and access ArgoCD an Ingress is also specified.
