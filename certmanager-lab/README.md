                                                                    🛡️ TLS Automático com CertManager & Let's Encrypt - SRE DevOps Zone

🌟 Objetivo
Configurar emissão automática de certificados HTTPS para aplicações hospedadas em um cluster Kubernetes (OKE) usando o CertManager com Let's Encrypt.

📊 Arquitetura
Usuário
   ↓ HTTPS
Ingress (NGINX) 
   ↓
Aplicativo 
   ↓
Kubernetes 

 + ExternalDNS atualiza os registros no Cloudflare automaticamente
 + CertManager solicita certificados Let's Encrypt via ACME

🚀 Tecnologias e Ferramentas
Oracle Cloud Infrastructure (OKE - Always Free)
Kubernetes
Helm
NGINX Ingress Controller
CertManager
Let's Encrypt (ACME)
Cloudflare (DNS + Proxy)
ExternalDNS
ArgoCD (CD)
Docker
GitHub
Grafana + Prometheus (monitoramento)

📗 Passo a Passo Detalhado

1. 📅 Domínio e Cloudflare
Domínio registrado: sredevops.com.br
Transferido da Hostinger para Cloudflare.
Nameservers da Cloudflare configurados na Hostinger.

2. ⚖️ Helm (Instalação)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

3. 🔌 NGINX Ingress Controller via Helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
Importante: guardar o ingressClassName para referência.

4. 📃 CertManager via Helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.14.4 \
  --set installCRDs=true

5. 📝 ClusterIssuer para Let's Encrypt
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: seu-email@sredevops.com.br
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - dns01:
        cloudflare:
          email: seu-email@sredevops.com.br
          apiTokenSecretRef:
            name: cloudflare-api-token-secret
            key: api-token
      selector:
        dnsZones:
        - 'sredevops.com.br'

6. 📊 ExternalDNS via Helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install external-dns bitnami/external-dns \
  --namespace external-dns --create-namespace \
  --set provider=cloudflare \
  --set cloudflare.apiTokenSecret.name=cloudflare-api-token-secret \
  --set cloudflare.apiTokenSecret.key=api-token \
  --set domainFilters[0]="sredevops.com.br" \
  --set policy=sync \
  --set txtOwnerId=default \
  --set sources[0]=ingress
Token Cloudflare com permissão de "Zone DNS Edit" é essencial.

7. ✨ Argo CD via Helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd --create-namespace \
  --set server.ingress.enabled=true \
  --set server.ingress.ingressClassName=nginx \
  --set server.ingress.annotations."kubernetes\.io/ingress\.class"=nginx \
  --set server.ingress.annotations."cert-manager\.io/cluster-issuer"=letsencrypt-prod \
  --set server.ingress.hosts[0]=argocd.sredevops.com.br \
  --set server.ingress.tls[0].hosts[0]=argocd.sredevops.com.br \
  --set server.ingress.tls[0].secretName=argocd-tls \
  --set server.config.url=https://argocd.sredevops.com.br

8. 🔑 Login e Repositório ArgoCD
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d

argocd login argocd.sredevops.com.br --username admin --password 'SENHA_DO_ARGO' --insecure

argocd repo add https://github.com/SidneyRochaM/argo-app.git \
  --username SidneyRochaM --password 'TOKEN_GITHUB' --insecure

9. 🌟 Deploy de aplicações HTML
Aplicativo Docker simples com HTML estático versionado e entregue via Argo CD.

10. 📊 Monitoramento
Grafana e Prometheus configurados para observabilidade do cluster OKE.

🚀 Resultados Alcançados
✅ CertManager emitindo certificados TLS válidos automaticamente
✅ Domínio customizado funcional via Cloudflare
✅ ExternalDNS atualizando domínios de forma automática
✅ Argo CD operando com HTTPS + deploy contínuo
✅ Monitoramento via Grafana
