terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  cloud {
    organization = "devops-llabbe"

    workspaces {
      name = "crud-app-terraform"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}


resource "tls_private_key" "id_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.id_rsa.public_key_openssh
}



resource "aws_instance" "web_server" {
  # count         = var.number_of_instances # create 2 ec2 instances
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = aws_key_pair.key_pair.id
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  #associate_with_private_ip = "10.0.1.50"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.network-web.id
    #network_interface_id = aws_network_interface.network-web[count.index].id

  }

  tags = {
    Name = "${var.environment}-web-server"
    #Name = "${var.environment}-web-server ${count.index}"
    Environment = var.environment
  }
  user_data = file("${path.module}/init.sh")
}

resource "aws_instance" "db_server" {
  # count         = var.number_of_instances # create 2 ec2 instances
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.id

  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private-subnet.id
  private_ip                  = "10.0.1.50"
  vpc_security_group_ids      = [aws_security_group.sg-db.id]

  tags = {
    Name        = "${var.environment}-db-server"
    Environment = var.environment
  }
  user_data = file("${path.module}/init_db.sh")

  depends_on = [aws_nat_gateway.public-nat]
}


resource "aws_network_interface" "network-web" {
  #count = var.number_of_nics
  subnet_id       = aws_subnet.public-subnet.id
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.sg-web.id]
}


resource "aws_vpc" "prod-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name

  tags = {
    Name        = "${var.environment}-VPC"
    Environment = var.environment
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
  }
}

#PRIVATE SUBNET FOR BACKEND PURPOSES WITH REFERENCE TO NAT GATEWAY IN ORDER TO ACCESS AND REACH THE OUTSIDE WORLD VIA THE INTERNET GATEWAY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
  }
}







resource "aws_route_table" "route-table-db" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public-nat.id
  }



  tags = {
    Name        = "${var.environment}-rt-db"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "rta-db" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.route-table-db.id
}














resource "aws_route_table" "route-table-web" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gateway.id
  }

  tags = {
    Name        = "${var.environment}-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "rta-web" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.route-table-web.id
}







resource "aws_security_group" "sg-web" {
  name        = "allow_web"
  description = "Allow http/https inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["51.154.203.242/32"]
  }
  ingress {
    description = "REACT FRONT"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "NODE JS"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.home_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.environment}-sg-web"
    Environment = var.environment
  }
}

resource "aws_security_group" "sg-db" {
  name        = "allow_private"
  description = "Allow incoming traffic from public subnet"
  vpc_id      = aws_vpc.prod-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  ingress {
    description = "MONGO"
    from_port   = 27017
    to_port     = 27030
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-sg-web"
    Environment = var.environment
  }
}




resource "aws_eip" "eip-web" {
  #for_each = aws_instance.web_server
  #instance   = each.value.id
  instance   = aws_instance.web_server.id
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_eip" "eip-nat" {
  #for_each = aws_instance.web_server
  #instance   = each.value.id
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}



resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name        = "${var.environment}-gateway"
    Environment = var.environment
  }
}


resource "aws_nat_gateway" "public-nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.public-subnet.id


  tags = {
    Name        = "${var.environment}-public-nat"
    Environment = var.environment
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gateway]
}

# THIS IS A PRIVATE NAT GATEWAY

#resource "aws_nat_gateway" "example" {
#  connectivity_type = "private"
#  subnet_id         = aws_subnet.example.id
#









resource "aws_iam_role" "deploy-ec2-role" {
  name = "DEPLOY-EC2-SERVICE-ROLE"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy-ec2-codedeploy" {
  role       = aws_iam_role.deploy-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "EC2_CODEDEPLOY_PROFILE"
  role = aws_iam_role.deploy-ec2-role.name
}









resource "aws_iam_role" "codedeploy-role" {
  name = "CODEDEPLOY-ROLE"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}




resource "aws_iam_role_policy_attachment" "policy-codedeploy" {
  role       = aws_iam_role.codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "policy-ec2-faccess" {
  role       = aws_iam_role.codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "policy-codedeploy-faccess" {
  role       = aws_iam_role.codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}


resource "aws_codedeploy_app" "crud_app" {
  name = "CRUD_APP"
}


resource "aws_codedeploy_deployment_group" "deployment-group-ec2" {
  app_name               = aws_codedeploy_app.crud_app.name
  deployment_group_name  = "FRONT_DG"
  service_role_arn       = aws_iam_role.codedeploy-role.arn
  deployment_config_name = aws_codedeploy_deployment_config.deployment-config-ec2.id

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "${var.environment}-web-server"
    }
  }
  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

resource "aws_codedeploy_deployment_config" "deployment-config-ec2" {
  deployment_config_name = "FRONT_DC"
  compute_platform       = "Server"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }

}
