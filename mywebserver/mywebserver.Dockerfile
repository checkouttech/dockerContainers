FROM ubuntu
RUN apt-get update
RUN apt-get install -y nginx
COPY index.html /var/www/html/
#ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]
ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]
#ENTRYPOINT ["/usr/sbin/nginx"]
EXPOSE 80
