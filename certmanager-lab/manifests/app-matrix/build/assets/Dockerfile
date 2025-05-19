# Imagem base
FROM nginx:alpine

# Remove arquivos default do nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia todos os arquivos do seu site para o nginx
COPY . /usr/share/nginx/html/

# Expor a porta padrão do nginx
EXPOSE 80

# Inicia o nginx em foreground
CMD ["nginx", "-g", "daemon off;"]