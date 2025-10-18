resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "eks-vpc"
  }
}





resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "eks-igw"
  }
}


resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name                     = "eks-public-subnet-1"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name                     = "eks-public-subnet-2"
    "kubernetes.io/role/elb" = "1"
  }
}

# ------------------------
# Private Subnets
# ------------------------
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name                              = "eks-private-subnet-1"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name                              = "eks-private-subnet-2"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "eks-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = "eks-nat-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks-private-rt"
  }
}


resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Associate Private Subnets
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

