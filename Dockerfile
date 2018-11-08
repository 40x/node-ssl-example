# base image
FROM nginx

# copy our dist, NGINX server serves content from this folder
COPY dist/node-ssl-example /usr/share/nginx/html

# copy SSL certificates to the NGINX server
RUN mkdir /etc/letsencrypt

COPY letsencrypt/live/ssl.kashyap.work/fullchain.pem /etc/letsencrypt

COPY letsencrypt/live/ssl.kashyap.work/privkey.pem /etc/letsencrypt

# remove current configuration
RUN rm /etc/nginx/conf.d/default.conf

# add our custom configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf