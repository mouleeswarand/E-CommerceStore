

# SkillTest3:  Deploy a Multi-Service Node.js E-commerce Application Using Terraform and Docker

## Background
This project provisions AWS infrastructure using Terraform and deploys a multi-service Node.js e-commerce application. The application consists of one frontend and four backend services (User, Products, Orders, Cart). Each service is containerized using Docker and deployed onto an AWS EC2 instance.

## Architecture Overview
*   **Cloud Provider**: AWS
*   **Infrastructure as Code**: Terraform
*   **Containerization**: Docker
*   **Services**:
    *   Frontend (Port 3000)
    *   User Service (Port 3001)
    *   Products Service (Port 3002)
    *   Orders Service (Port 3003)
    *   Cart Service (Port 3004)

## Prerequisites
*   AWS CLI installed and configured with appropriate IAM permissions.
*   Terraform installed.
*   Docker installed locally for building images.
*   Docker Hub account.

---

## Step 1: Application Setup (Docker)

1. **Dockerfiles Creation**: Created lightweight `Dockerfile`s for each of the 5 Node.js services.

```
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3000   #this port number will get changed as per the service
CMD ["npm", "start"]

```

**docker-compose.yaml file**

```
version: '3.8'

services:
  frontend:
    build: ./frontend
    container_name: ecommerce-frontend
    ports:
      - "3000:3000"
    restart: unless-stopped

  user:
    build: ./backend/user-service
    container_name: ecommerce-user
    ports:
      - "3001:3001"
    restart: unless-stopped

  products:
    build: ./backend/product-service
    container_name: ecommerce-products
    ports:
      - "3002:3002"
    restart: unless-stopped

  orders:
    build: ./backend/order-service
    container_name: ecommerce-orders
    ports:
      - "3003:3003"
    restart: unless-stopped

  cart:
    build: ./backend/cart-service
    container_name: ecommerce-cart
    ports:
      - "3004:3004"
    restart: unless-stopped
```

2. **Build and Tag**: Built the images locally using the following commands:

``` docker compose up --build -d ```    # this will build and run the container locally

```bash
docker tag e-commercestore-cart:latest ryan29/e-commercestore-cart:latest
docker tag e-commercestore-orders:latest ryan29/e-commercestore-orders:latest
docker tag e-commercestore-frontend:latest ryan29/e-commercestore-frontend:latest
docker tag e-commercestore-products:latest ryan29/e-commercestore-products:latest
docker tag e-commercestore-user:latest ryan29/e-commercestore-user:latest
```

   
3. **Push to Docker Hub**:
   ```bash
   docker push ryan29/e-commercestore-frontend:latest
   docker push ryan29/e-commercestore-user:latest
   docker push ryan29/e-commercestore-products:latest
   docker push ryan29/e-commercestore-orders:latest
   docker push ryan29/e-commercestore-cart:latest
   ```

## Docker - Local Output Screenshot

<img width="958" height="211" alt="image" src="https://github.com/user-attachments/assets/f3c14c66-4f37-4f58-a495-caa495af17cd" />


## http://localhost:3000
<img width="1541" height="916" alt="image" src="https://github.com/user-attachments/assets/fb641254-2ddd-43f5-b694-df17b034431b" />

<img width="430" height="145" alt="image" src="https://github.com/user-attachments/assets/a2b4cb2e-a6dd-4341-847d-41a7403b0774" />

<img width="431" height="153" alt="image" src="https://github.com/user-attachments/assets/6a8c0cd6-9ae5-4100-8431-7a0c774fcadf" />




---

## Step 2: Infrastructure Provisioning (Terraform)

The Terraform configuration (`main.tf`) provisions the following resources:
*   **VPC & Subnet**: A default/custom VPC with a public subnet to ensure internet accessibility.
*   **Security Group**: 
    *   Inbound TCP Port `3000` (Frontend)
    *   Inbound TCP Ports `3001-3004` (Internal Backend Services)
    *   Inbound TCP Port `22` (SSH for debugging)
    *   Outbound all traffic.
*   **EC2 Instance**: An Ubuntu 22.04 instance.
*   **User Data Script**: A bootstrap script attached to the EC2 instance that automatically:
    *   Installs Docker.
    *   Starts the Docker service.
    *   Pulls the 5 images from Docker Hub.
    *   Runs the containers mapping the respective ports.

### Terraform Commands Used
```bash
terraform init
terraform fmt
terraform plan
terraform apply -auto-approve
terraform state list
terraform output
terraform destroy
```

---

## Step 3: Deployment and Accessibility


### gotto terraform folder (https://github.com/mouleeswarand/E-CommerceStore/tree/main/terraform)  to see the terraform code
```
providers.tf
main.tf
versions.tf
variables.tf
terraform.tfvars
outputs.tf
data.tf
user_data.sh
```



Upon successful `terraform apply`, Terraform outputs the Public IP of the EC2 instance. 
Access the frontend by navigating to: `http://<EC2_PUBLIC_IP>:3000`

---

## Evidence & Screenshots


### 1. Docker Images on Docker Hub
<img width="1680" height="492" alt="image" src="https://github.com/user-attachments/assets/6bbfb39c-5333-4654-b3c4-30034a204e9e" />


### 2. Terraform Apply Output
<img width="895" height="345" alt="image" src="https://github.com/user-attachments/assets/18438fe4-f77f-41e4-b5de-69ede513bec3" />


### 3. AWS Console - EC2 Running
<img width="1612" height="542" alt="image" src="https://github.com/user-attachments/assets/2667c157-2e90-429a-9f42-80ab5e43450a" />


### 4. Frontend Application Live
<img width="1524" height="912" alt="image" src="https://github.com/user-attachments/assets/4c5bd45d-c14a-4f70-a56d-9c4ce0a563aa" />


### 5. Backend Services Verification (Optional but Recommended)

<img width="517" height="150" alt="image" src="https://github.com/user-attachments/assets/1d6b806f-4b18-4b0f-b397-6d7a26f7a5bc" />

<img width="556" height="161" alt="image" src="https://github.com/user-attachments/assets/320b52f5-26fb-4ed0-b2d5-1eadad741967" />

<img width="475" height="157" alt="image" src="https://github.com/user-attachments/assets/a96075bc-73c1-46d5-b889-01d0d221a849" />

<img width="477" height="158" alt="image" src="https://github.com/user-attachments/assets/b06ef074-fce0-4a32-8398-ea6d9948ba0d" />




---
**Cleanup**:
To destroy the infrastructure and avoid AWS charges:
```bash
terraform destroy -auto-approve
```


















