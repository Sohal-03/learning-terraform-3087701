provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "blog" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "blog" {
  name = http
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "http_in" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"

  security_group_id = aws_security_group.blog.id
}
