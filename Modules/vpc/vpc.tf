#data "aws_region" "current" {}

locals {
  aws_region = "${data.aws_region.current.name}"
}

#Create VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "dg_vpc"
  }
}

output "aws_vpc_default_id" {
  value = "${aws_vpc.default.id}"
}

#Create public subnet 1
resource "aws_subnet" "dg_subnet1" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "dg_subnet1"
  }
}

//Public Subnet 2
resource "aws_subnet" "dg_subnet2" {
  vpc_id     = "${aws_vpc.default.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "dg_subnet2"
  }
}

#Create internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

#Create private subnet 1 to launch our instance to zone A
resource "aws_subnet" "az_1" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${local.aws_region}a"

  tags {
    Name = "dg_vpc_private_az1"
  }
}

output "aws_subnet_az_1_id" {
  value = "${aws_subnet.az_1.id}"
}

#Route table for public subnet
resource "aws_route_table" "dgroutetable" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "${var.anywhere}"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "dg_routetable"
  }
}

#Gateway Route table association to subnet 1
resource "aws_route_table_association" "association1" {
  count          = 2
  subnet_id      = "${aws_subnet.dg_subnet1.id}"
  route_table_id = "${aws_route_table.dgroutetable.id}"
}

#Gateway Route table association to subnet 2
resource "aws_route_table_association" "association2" {
  count          = 2
  subnet_id      = "${aws_subnet.dg_subnet2.id}"
  route_table_id = "${aws_route_table.dgroutetable.id}"
}

#Create Elastic IP to use for NAT gateway
resource "aws_eip" "dg_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

output "aws_eip_nat_eip" {
  value = "${aws_eip.dg_eip.public_ip}"
}

#NAT gateway allow ec2 instance access outside
resource "aws_nat_gateway" "dg_nat_1" {
  allocation_id = "${aws_eip.dg_eip.id}"
  subnet_id     = "${aws_subnet.dg_subnet1.id}"
  depends_on    = ["aws_internet_gateway.default"]
}

#NAT Gateway Route table
resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dg_nat_1.id}"
  }
}

#NAT Route for private subnet 

resource "aws_route_table_association" "dg_nat_ass1" {
  subnet_id      = "${aws_subnet.az_1.id}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}
