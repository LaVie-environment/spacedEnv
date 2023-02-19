provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "uat" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

terraform {
  backend "s3" {
    bucket = "works-up-and-running-state"
    key = "workspaces-uat/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "works-up-and-running-state"
    encrypt = true
  }
}
