resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  tags {
   Name = "${var.shortname}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.shortname}-igw"
  }
}

resource "aws_subnet" "main" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_cidr}"

    tags {
        Name = "${var.shortname}-subnet"
    }
    map_public_ip_on_launch = true
}

resource "aws_route_table" "default_gw" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags {
        Name = "${var.shortname}-Default-Table"
    }
}
