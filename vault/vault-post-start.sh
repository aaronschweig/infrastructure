# grant read access to "secret" kv store
printf 'path "secret/*"{\ncapabilities=["read"]\n}' | vault policy write argocd-policy -

# enable k8s authentication
vault auth enable kubernetes

# configure k8s authentication
vault write auth/kubernetes/config kubernetes_host=https://kubernetes.default.svc:443

# write role for default service account to access vault from every namespace
vault write auth/kubernetes/role/argocd bound_service_account_names=default bound_service_account_namespaces="*" policies="argocd-policy"