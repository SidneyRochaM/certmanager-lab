# CertManager com Let's Encrypt - sredevops.com.br

## 💡 Visão Geral
Configuração automática de certificados TLS com Let's Encrypt gerenciados via Cloudflare.

## 🔧 Pré-requisitos
- Cluster Kubernetes (OKE)
- Domínio `sredevops.com.br` configurado na Cloudflare
- Helm instalado

## 📦 Componentes
- CertManager
- Ingress-NGINX
- Let's Encrypt (ClusterIssuer)
- ExternalDNS (Cloudflare)

## 🚀 Instalação

### 1. CertManager
```bash
bash helm/cert-manager-install.sh
kubectl apply -f manifests/clusterissuer-letsencrypt-prod.yaml
```

### 2. Ingress Controller
```bash
bash helm/ingress-nginx-install.sh
```

### 3. Aplicação
```bash
kubectl apply -f manifests/minha-app/
```

### 4. ExternalDNS
```bash
bash helm/externaldns-install.sh
```

## ✅ Teste
- Acessar: https://app.sredevops.com.br
