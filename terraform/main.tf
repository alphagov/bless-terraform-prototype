resource "aws_vpc" "bless_example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.bless_example.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.bless_example.id}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.bless_example.id}"
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_security_group" "ssh_from_bastion" {
  vpc_id      = "${aws_vpc.bless_example.id}"
  name        = "SSH from bastion"
  description = "Allows SSH access from bastion"

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.ssh_from_internet.id}"]
  }

  tags {
    Name = "SSH from bastion"
  }
}

resource "aws_security_group" "ssh_from_internet" {
  vpc_id      = "${aws_vpc.bless_example.id}"
  name        = "SSH from internet"
  description = "Bastion hosts in the DMZ that can be connected to via SSH from whitelisted locations"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${var.cidr_admin_whitelist}"]
  }

  tags {
    Name = "SSH from internet"
  }
}

resource "aws_instance" "bastion" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"

    # The connection will use the local SSH agent for authentication.
  }

  associate_public_ip_address = true

  instance_type = "t2.micro"
  ami = "ami-c593deb6" # Ubuntu Xenial 16.04

  key_name = "work-macbook-air"

  # Our Security group to allow SSH access
  vpc_security_group_ids = ["${aws_security_group.ssh_from_internet.id}"]

  subnet_id = "${aws_subnet.default.id}"

  # We run a remote provisioner on the instance after creating it.
  provisioner "remote-exec" {
    inline = [
      "echo hello world",
    ]
  }
}
