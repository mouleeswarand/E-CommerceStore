

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

















# The following content are forked from the previous REPO

# E-Commerce Microservices Application

A full-stack MERN e-commerce application built with microservices architecture, featuring 4 separate Node.js backend services and a React frontend.

## 🏗️ Architecture Overview

This application demonstrates modern microservices architecture with the following components:

```
Frontend (React) → API Gateway → Microservices
                                    ├── User Service (3001)
                                    ├── Product Service (3002)
                                    ├── Cart Service (3003)
                                    └── Order Service (3004)
```

## 🔧 Technology Stack

### Backend
- **Runtime**: Node.js with Express.js
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT tokens
- **Architecture**: RESTful APIs with microservices

### Frontend
- **Framework**: React 18
- **Routing**: React Router
- **State Management**: React Query + Context API
- **HTTP Client**: Axios
- **Styling**: CSS3 with responsive design

## 📦 Microservices

### 1. User Service (Port 3001)
- User registration and authentication
- Profile management
- JWT token generation and validation
- User data persistence

**Endpoints:**
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User authentication
- `GET /api/auth/me` - Get current user
- `GET /api/users/profile` - Get user profile
- `PUT /api/users/profile` - Update user profile

### 2. Product Service (Port 3002)
- Product catalog management
- Category management
- Product search and filtering
- Inventory tracking

**Endpoints:**
- `GET /api/products` - Get products with filtering/pagination
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product (admin)
- `PUT /api/products/:id` - Update product (admin)
- `DELETE /api/products/:id` - Soft delete product (admin)
- `GET /api/categories` - Get all categories
- `POST /api/categories` - Create category (admin)

### 3. Cart Service (Port 3003)
- Shopping cart management
- Add/remove/update cart items
- Cart validation
- Integration with Product Service

**Endpoints:**
- `GET /api/cart/:userId` - Get user's cart
- `POST /api/cart/:userId/items` - Add item to cart
- `PUT /api/cart/:userId/items/:productId` - Update cart item
- `DELETE /api/cart/:userId/items/:productId` - Remove cart item
- `DELETE /api/cart/:userId` - Clear entire cart
- `POST /api/cart/:userId/validate` - Validate cart items

### 4. Order Service (Port 3004)
- Order creation and management
- Payment processing simulation
- Order status tracking
- Integration with Cart and Product Services

**Endpoints:**
- `GET /api/orders/user/:userId` - Get user's orders
- `GET /api/orders/:id` - Get single order
- `POST /api/orders` - Create new order
- `PUT /api/orders/:id/status` - Update order status
- `DELETE /api/orders/:id` - Cancel order
- `POST /api/payments/process` - Process payment
- `POST /api/payments/refund` - Process refund

## 🚀 Getting Started

### Prerequisites
- Node.js 16+ and npm
- MongoDB (local or cloud instance)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd ecommerce-microservices
```

2. **Install dependencies for each service**
```bash

# Install User Service dependencies
cd backend/user-service && npm install

# Install Product Service dependencies
cd ../product-service && npm install

# Install Cart Service dependencies
cd ../cart-service && npm install

# Install Order Service dependencies
cd ../order-service && npm install

# Install Frontend dependencies
cd ../../frontend && npm install
```

3. **Set up environment variables**

Create `.env` files in each service directory:

**backend/user-service/.env:**
```env
PORT=3001
MONGODB_URI=mongodb://localhost:27017/ecommerce_users
JWT_SECRET=your-jwt-secret-key
```

**backend/product-service/.env:**
```env
PORT=3002
MONGODB_URI=mongodb://localhost:27017/ecommerce_products
```

**backend/cart-service/.env:**
```env
PORT=3003
MONGODB_URI=mongodb://localhost:27017/ecommerce_carts
PRODUCT_SERVICE_URL=http://localhost:3002
```

**backend/order-service/.env:**
```env
PORT=3004
MONGODB_URI=mongodb://localhost:27017/ecommerce_orders
CART_SERVICE_URL=http://localhost:3003
PRODUCT_SERVICE_URL=http://localhost:3002
USER_SERVICE_URL=http://localhost:3001
```

**frontend/.env:**
```env
REACT_APP_USER_SERVICE_URL=http://localhost:3001
REACT_APP_PRODUCT_SERVICE_URL=http://localhost:3002
REACT_APP_CART_SERVICE_URL=http://localhost:3003
REACT_APP_ORDER_SERVICE_URL=http://localhost:3004
```

### Running the Application


** Run services individually**

Terminal 1 - User Service:
```bash
cd backend/user-service && npm start
```

Terminal 2 - Product Service:
```bash
cd backend/product-service && npm start
```

Terminal 3 - Cart Service:
```bash
cd backend/cart-service && npm start
```

Terminal 4 - Order Service:
```bash
cd backend/order-service && npm start
```

Terminal 5 - Frontend:
```bash
cd frontend && npm start
```

The application will be available at:
- Frontend: http://localhost:3000
- User Service: http://localhost:3001
- Product Service: http://localhost:3002
- Cart Service: http://localhost:3003
- Order Service: http://localhost:3004

## 🎯 Features

### User Features
- **Authentication**: Register and login with JWT tokens
- **Product Browsing**: View products with search, filtering, and pagination
- **Shopping Cart**: Add, update, and remove items
- **Checkout Process**: Complete order placement with shipping and payment
- **Order Management**: View order history and track status
- **Profile Management**: Update personal information and addresses

### Admin Features (Future Enhancement)
- Product and category management
- Order status updates
- Inventory management
- User management

### Technical Features
- **Microservices Architecture**: Loosely coupled services
- **RESTful APIs**: Standard HTTP methods and status codes
- **Data Validation**: Input validation and error handling
- **Cross-Service Communication**: HTTP-based service interactions
- **Responsive Design**: Mobile-friendly user interface
- **Error Handling**: Comprehensive error management
- **Loading States**: User-friendly loading indicators

## 📁 Project Structure

```
ecommerce-microservices/
├── backend/
│   ├── user-service/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── middleware/
│   │   ├── server.js
│   │   └── package.json
│   ├── product-service/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── server.js
│   │   └── package.json
│   ├── cart-service/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── server.js
│   │   └── package.json
│   └── order-service/
│       ├── models/
│       ├── routes/
│       ├── server.js
│       └── package.json
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── contexts/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── App.js
│   │   └── index.js
│   └── package.json
├── package.json
└── README.md
```

## 🔧 API Testing

You can test the APIs using tools like Postman or curl:

```bash
# Health check for all services
curl http://localhost:3001/health
curl http://localhost:3002/health
curl http://localhost:3003/health
curl http://localhost:3004/health

# Register a new user
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"john@example.com","password":"password123"}'

# Get products
curl http://localhost:3002/api/products

# Get categories
curl http://localhost:3002/api/categories
```

## 🚀 Deployment

### Production Considerations

1. **Environment Variables**: Use proper environment variable management
2. **Database**: Use MongoDB Atlas or other managed database services
3. **Process Management**: Use PM2 or similar for process management
4. **Load Balancing**: Implement load balancing for high availability
5. **Monitoring**: Add logging and monitoring solutions
6. **Security**: Implement rate limiting, CORS, and other security measures

### Docker Deployment (Future Enhancement)

Each service can be containerized with Docker:

```dockerfile
# Example Dockerfile for a service
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3001
CMD ["npm", "start"]
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
- Check the documentation
- Review API endpoints and expected payloads
- Ensure all services are running
- Verify database connections
- Check environment variables

## 🔮 Future Enhancements

- **API Gateway**: Centralized request routing and authentication
- **Docker Containerization**: Full containerization with docker-compose
- **Message Queues**: Async communication between services
- **Caching**: Redis caching for improved performance
- **Search Engine**: Elasticsearch for advanced product search
- **File Upload**: Image upload and management
- **Email Service**: Order confirmations and notifications
- **Admin Dashboard**: Administrative interface
- **Analytics**: Order and user analytics
- **Payment Integration**: Real payment gateway integration
