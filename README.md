# Adding important resources to the cluster

## ArgoCD

To enable a GitOps based workflow with easy deployments to the kubernetes cluster we use argocd. This autmagically generates a desired state out of a git repository and syncs it with the current state in the cluster.
This enabled an easy deployment workflow, with fine-grained controls.

To deploy ArgoCD we use their [helm chart](https://argoproj.github.io/argo-helm) with the overrides specified in the `argo/values.yaml` file. To expose and access ArgoCD an Ingress is also specified.
