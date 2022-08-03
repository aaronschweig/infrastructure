# grant read access to "secret" kv store
printf 'path "secret/*"{\ncapabilities=["read"]\n}' | vault policy write argocd-policy -

# enable k8s authentication
vault auth enable kubernetes

# configure k8s authentication
vault write auth/kubernetes/config kubernetes_host=https://kubernetes.default.svc:443

# write role for default service account to access vault from every namespace
vault write auth/kubernetes/role/argocd bound_service_account_names=argocd-server bound_service_account_namespaces="*" policies="argocd-policy"

# Give normal managing permissions to the OIDC user
printf 'path "secret/*" {\ncapabilities=["create", "read", "update", "delete", "list"]\n}' | vault policy write oidc-policy -

vault auth enable oidc

# Configure the OIDC method with ArgoCDs dex server
vault write auth/oidc/config oidc_client_id="vault-oidc" oidc_client_secret="$VAULT_CLIENT_SECRET" oidc_discovery_url="https://argocd.aaronschweig.dev/api/dex" default_role="oidc-role"

# Allow logging in via the CLI and the UI and assign the oidc-policy
vault write auth/oidc/role/oidc-role user_claim="sub" \
    allowed_redirect_uris="http://localhost:8250/oidc/callback,https://vault.aaronschweig.dev/ui/vault/auth/oidc/oidc/callback" \
    policies="oidc-policy"

# Make OIDC the default login method when visiting the UI
vault write sys/auth/oidc/tune listing_visibility="unauth"
