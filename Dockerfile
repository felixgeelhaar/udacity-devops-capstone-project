FROM nginx:1.17-alpine
COPY index.html /var/www/html/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]