FROM nginx

LABEL author="Jinghui Hu"

COPY . /usr/share/nginx/html

EXPOSE 80

CMD nginx -g "daemon off;"
