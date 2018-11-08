# Local Testing

1. Generate SSL certificates

sh ssl.sh

2. Build Docker image

docker build --rm -f "Dockerfile" -t node-ssl-example:latest .

3. Run image

docker run -d -p 80:4000 -p 443:8443 node-ssl-example:latest

4. Open https://localhost