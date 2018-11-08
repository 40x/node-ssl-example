FROM node:8

WORKDIR /usr/src/app

COPY package*.json ./

COPY letsencrypt ./letsencrypt

COPY dist ./dist

# optionally create a server only package.json
# which brings in express and other dependencies
RUN npm ci

COPY server.js ./

ENV NODE_ENV=production

EXPOSE 4000 8443

CMD ["node", "server"]