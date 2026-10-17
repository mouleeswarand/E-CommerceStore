
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true  # Fixed: Use raw booleans (no quotes)
  enable_dns_support   = true  # Fixed: Use raw booleans (no quotes)
  
  tags = {
    Name = "ecommerce-vpc"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "ecommerce-IGW"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # Fixed: Use raw booleans (no quotes)
  tags                    = { Name = "ecommerce-public-subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  # Fixed: Changed destination to all traffic (0.0.0.0/0) and directed it to your IGW.
  # The "local" routing rule is handled by AWS behind the scenes.
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "ecommerce-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id # Fixed: Stripped out the literal string quotes and brackets
}

resource "aws_security_group" "this" {
  name        = "ecommerce-sg"
  vpc_id      = aws_vpc.this.id
  description = "Allow all the allowed ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows port range 3000 to 3004 for your Docker frontend and backend services
  ingress {
    from_port   = 3000
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ecommerce_server" {
  ami           = data.aws_ami.ubuntu.id
  key_name = "capstone"
  instance_type = "t3.micro" # Recommendation: Switched to t2.micro to qualify for AWS Free Tier limits. Change back to t2.medium if you prefer.

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.this.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    docker_username = var.docker_username
    docker_password = var.docker_password
  })

  tags = {
    Name = "ECommerce-Docker-Host"
  }
}
