helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install external-dns bitnami/external-dns \
  --namespace external-dns --create-namespace \
  --set provider=cloudflare \
  --set cloudflare.apiKeySecret.name=external-dns \
  --set cloudflare.apiKeySecret.key=cloudflare_api_key \
  --set cloudflare.email='@gmail.com' \
  --set domainFilters[0]="dominio.com.br" \
  --set txtOwnerId=default \
  --set sources[0]=ingress \
  --set policy=sync

kubectl create secret generic external-dns \
  --from-literal=cloudflare_api_key='CLOUDFLARE_API_KEY' \
  --from-literal=cloudflare_api_email='EMAIL' \
  -n external-dns
