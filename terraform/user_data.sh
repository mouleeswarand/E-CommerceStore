#!/bin/bash
set -euo pipefail

# Allocate a 2GB swap file to handle the 5 Docker microservices on a micro instance
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab


# ... rest of your docker setup script ...

sudo apt update && sudo apt upgrade -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# These placeholders will safely be replaced by Terraform
echo "${docker_password}" | docker login -u "${docker_username}" --password-stdin

docker run -d -p 3000:3000 --name frontend ryan29/e-commercestore-frontend:latest
docker run -d -p 3001:3001 --name user-service ryan29/e-commercestore-user:latest
docker run -d -p 3002:3002 --name product-service ryan29/e-commercestore-products:latest
docker run -d -p 3003:3003 --name cart-service ryan29/e-commercestore-cart:latest
docker run -d -p 3004:3004 --name order-service ryan29/e-commercestore-orders:latest




