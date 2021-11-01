1. set variables in terraform.tfvars
2. Get `HCLOUD_TOKEN`
3. terraform plan
4. terraform apply
5. terraform output > tf.json
6. ssh-agent needs to be running and id_rsa must be added, so that the SSH_SOCKET thing works
6. kubeone apply -m kubeone.yaml -t tf.json
7. helm install traefik with values.yaml (LoadBalancer Config, as well as tls resolver infos)
8. helm install argocd with configuration (server.extraArgs: [--insecure] && server.ingress.enabled=true)
9. Ready to kickstart your GitOps workflow!