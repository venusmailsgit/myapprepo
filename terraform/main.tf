# Define variables
variable "aws_region" {
  description = "AWS region where the resources will be created"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 Instance type"
  default = "t2.micro"
}

variable "instance_ami" {
  description = "EC2 Instance machine image"
  default = "ami-090e0fc566929d98b"  # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type (x86)
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

# Create VPC
resource "aws_vpc" "muthoot_vpc" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "MuthootVPC"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.muthoot_vpc.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "PublicSubnet"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.muthoot_vpc.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "PrivateSubnet"
  }
}

# Create security group
resource "aws_security_group" "muthoot_sg" {
  vpc_id = aws_vpc.muthoot_vpc.id

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

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MuthootSecurityGroup"
  }
}

# Provision EC2 instances
resource "aws_instance" "muthoot_instance" {
  count         = 2
  instance_type = var.instance_type
  ami           = var.instance_ami  

  subnet_id         = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  key_name = "PrivKeyus-east-1"

  vpc_security_group_ids = [aws_security_group.muthoot_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd docker
    sudo systemctl enable httpd docker
    sudo service httpd start
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    echo '<h1>OneMuthoot - APP-1</h1>' | sudo tee /var/www/html/index.html
    sudo mkdir /var/www/html/app1
    echo '<!DOCTYPE html> <html> <body style="background-color:rgb(250, 210, 210);"> <h1>OneMuthoot - APP-1</h1> <p>Terraform Demo</p> <p>Application Version: V1</p> </body></html>' | sudo tee /var/www/html/app1/index.html
    curl http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app1/metadata.html
    sudo docker pull silentassassin11/muthoot-repo:v1
    sudo docker run -d -p 8080:8080 silentassassin11/muthoot-repo:v1
    EOF

  tags = {
    Name = "MuthootInstance-${count.index}"
  }
}

resource "aws_internet_gateway" "muthoot_igw" {
  vpc_id = aws_vpc.muthoot_vpc.id

  tags = {
    Name = "MuthootIGW"
  }
}

resource "aws_route" "muthoot_default_route" {
  route_table_id         = aws_vpc.muthoot_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.muthoot_igw.id
}

# Configure Classic Load Balancer
resource "aws_elb" "muthoot_elb" {
  name               = "MuthootELB"
  subnets         = [aws_subnet.public_subnet.id]
  security_groups  = [aws_security_group.muthoot_sg.id]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:8080/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  instances = aws_instance.muthoot_instance.*.id

  cross_zone_load_balancing   = true
  idle_timeout               = 400
  connection_draining        = true
  connection_draining_timeout = 400

  tags = {
    Name = "MuthootELB"
  }
}