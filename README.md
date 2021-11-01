# Hetzner Quickstart Terraform configs

The Hetzner Quickstart Terraform configs can be used to create the needed
infrastructure for a Kubernetes HA cluster. Check out the following
[Creating Infrastructure guide][docs-infrastructure] to learn more about how to
use the configs and how to provision a Kubernetes cluster using KubeOne.

## Kubernetes API Server Load Balancing

See the [Terraform loadbalancers in examples document][docs-tf-loadbalancer].

[docs-infrastructure]: https://docs.kubermatic.com/kubeone/master/infrastructure/terraform_configs/
[docs-tf-loadbalancer]: https://docs.kubermatic.com/kubeone/master/advanced/example_loadbalancer/
[traefik-ingress]: https://doc.traefik.io/traefik/
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_name | prefix for cloud resources | string | n/a | yes |
| control\_plane\_type |  | string | `"cx21"` | no |
| datacenter |  | string | `"fsn1"` | no |
| image |  | string | `"ubuntu-18.04"` | no |
| lb\_type |  | string | `"lb11"` | no |
| ssh\_agent\_socket | SSH Agent socket, default to grab from $SSH_AUTH_SOCK | string | `"env:SSH_AUTH_SOCK"` | no |
| ssh\_port | SSH port to be used to provision instances | string | `"22"` | no |
| ssh\_private\_key\_file | SSH private key file used to access instances | string | `""` | no |
| ssh\_public\_key\_file | SSH public key file | string | `"~/.ssh/id_rsa.pub"` | no |
| ssh\_username | SSH user, used only in output | string | `"root"` | no |
| worker\_os | OS to run on worker machines | string | `"ubuntu"` | no |
| worker\_type |  | string | `"cx21"` | no |

## Outputs

| Name | Description |
|------|-------------|
| kubeone\_api | kube-apiserver LB endpoint |
| kubeone\_hosts | Control plane endpoints to SSH to |
| kubeone\_workers | Workers definitions, that will be transformed into MachineDeployment object |

# Adding important resources to the cluster


## Traefik

One important resource to add is an Ingress-Controller to enable communication between the outside world and the kubernets cluster.
In our case we are using [traefik][traefik-ingress] as an Ingress-Controller. To set everything up, we just use the traefik helm chart from their [official repo](https://helm.traefik.io/traefik) with some custom overrides in the `traefik/values.yaml` file.
Some important fields to change, based on the deployment:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| --certificateresolvers.cloudflare.acme.email | Email-Adress to acquire Lets-Encrypt Certificates | string | n/a | yes |
| --certificateresolvers.cloudflare.acme.dnschallenge.provider | Specifies to use the DNS-Challenge mechanism (only needed for Wildcard certificates) | string | n/a | yes |
| --entrypoints.websecure.http.tls.domains[0].main=aaronschweig.dev | The Domain which is used by the resources of the Ingress-Controller | string | n/a | yes |

Also the `load-balancer.hetzner.cloud/name` annotation needs to be checked to match the generated resource by terraform.

## ArgoCD

To enable a GitOps based workflow with easy deployments to the kubernetes cluster we use argocd. This autmagically generates a desired state out of a git repository and syncs it with the current state in the cluster.
This enabled an easy deployment workflow, with fine-grained controls.

To deploy ArgoCD we use their [helm chart](https://argoproj.github.io/argo-helm) with the overrides specified in the `argo/values.yaml` file. To expose and access ArgoCD an Ingress is also specified.