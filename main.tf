# Ref
# Getting latest Ubuntu AMI with Terraform
# https://www.andreagrandi.it/2017/08/25/getting-latest-ubuntu-ami-with-terraform/


data "aws_ami" "web" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  #owners = ["amazon"] amazon linux2

    filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
      #values = ["amzn2-ami-hvm-*-x86_64-ebs"]

    }

    filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }
}


resource "aws_instance" "web" {
  ami           = data.aws_ami.web.id
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_id              = aws_subnet.web.id
  instance_type = "t2.micro" 
  key_name = var.ssh_key_name
  user_data = file("user_data.sh")
  tags = {
    "key" = "web"
  }
}
