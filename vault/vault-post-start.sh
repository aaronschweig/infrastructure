# grant read access to "secret" kv store
printf 'path "secret/*"{\ncapabilities=["read"]\n}' | vault policy write argocd-policy -

# enable k8s authentication
vault auth enable kubernetes

# configure k8s authentication
vault write auth/kubernetes/config kubernetes_host=https://kubernetes.default.svc:443

# write role for default service account to access vault from every namespace
vault write auth/kubernetes/role/argocd bound_service_account_names=argocd-repo-server bound_service_account_namespaces="*" policies="argocd-policy"

printf 'path "secret/*" {\ncapabilities=["create", "read", "update", "delete", "list"]\n}' | vault policy write oidc-policy -

vault auth enable oidc

vault write auth/oidc/config oidc_client_id="vault-oidc" oidc_client_secret="$VAULT_CLIENT_SECRET" oidc_discovery_url="https://argocd.aaronschweig.dev/api/dex" default_role="oidc-role"

vault write auth/oidc/role/oidc-role user_claim="sub" \
    allowed_redirect_uris="http://localhost:8250/oidc/callback,https://vault.aaronschweig.dev/ui/vault/auth/oidc/oidc/callback" \
    policies="oidc-policy"