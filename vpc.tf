# Ref
# TerraformでVPC・EC2インスタンスを構築してssh接続する - Qiita
# https://qiita.com/kou_pg_0131/items/45cdde3d27bd75f1bfd5

resource "aws_vpc" "web" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "web"
  }
}

resource "aws_subnet" "web" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.web.id


  map_public_ip_on_launch = true

  tags = {
    Name = "web"
  }
}

resource "aws_internet_gateway" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "web"
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "web"
  }
}

resource "aws_route" "web" {
  gateway_id             = aws_internet_gateway.web.id
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.web.id
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.web.id
  name   = "web"

  tags = {
    Name = "web"
  }
}

resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.web.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "in_http" {
  security_group_id = aws_security_group.web.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "in_customport_socialfish" {
  security_group_id = aws_security_group.web.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 5000
  to_port           = 5000
  protocol          = "tcp"
}


resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.web.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}