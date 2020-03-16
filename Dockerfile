FROM nginx:1.17-alpine
COPY index.html /usr/share/nginx/html
EXPOSE 80