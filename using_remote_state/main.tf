provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

## Remote states

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "tfmeetup-remote-state"
    key    = "mystate.tfstate"
    region = "us-west-2"
  }
}

data "aws_subnet" "selected" {
  id = "${data.terraform_remote_state.vpc.aws_subnet}"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "web" {
  vpc_id = "${data.aws_subnet.selected.vpc_id}"

  ingress {
    cidr_blocks = ["${data.aws_subnet.selected.cidr_block}"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}

resource "aws_instance" "web" {
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  subnet_id = "${data.aws_subnet.selected.id}"
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  tags {
    Name       = "${var.shortname}"
    created_by = "terraform"
  }
}
