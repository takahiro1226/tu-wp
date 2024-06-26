# rt = route table
# r = route
#

# ---------------------------------------------
# vpc設定
# ---------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# subnet (us-east-1a,us-east-1b)
# ---------------------------------------------

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1b"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1b"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1b"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# ---------------------------------------------
# route table (us-east-1a,us-east-1b)
# ---------------------------------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}
resource "aws_route_table_association" "public_rt_1b" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet_1b.id
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}
resource "aws_route_table_association" "private_rt_1b" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1b.id
}


# ---------------------------------------------
# Internet Gateway 設定
# ---------------------------------------------

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-internet-gateway"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_internet-gateway_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  ###外向きにすべての通信を許可
  gateway_id = aws_internet_gateway.internet-gateway.id
}