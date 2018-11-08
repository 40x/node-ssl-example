# Local testing

1. Generate SSL certs

sh ssl.sh

2. Build Docker image

docker build --rm -f "Dockerfile" -t node-ssl-example:latest .

3. Run image 

docker run -d -p 80:80 -p 443:443 node-ssl-example:latest

4. Open https://localhost