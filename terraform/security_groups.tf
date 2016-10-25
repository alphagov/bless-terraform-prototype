resource "aws_security_group" "expected_internet_traffic" {
  vpc_id      = "${aws_vpc.bless_example.id}"
  name        = "HTTP and NTP to internet"
  description = "Permitted to reach NTP and HTTP(S) servers on the internet"

  egress {
    protocol    = "udp"
    from_port   = 123
    to_port     = 123
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "HTTP(S) and NTP access to the internet"
  }
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
    Name = "SSH in from bastion"
  }
}

resource "aws_security_group" "ssh_within_vpc" {
  vpc_id      = "${aws_vpc.bless_example.id}"
  name        = "SSH in from bastion"
  description = "Allows bastion to SSH out to VPC"

  egress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = ["${aws_security_group.ssh_from_bastion.id}"]
  }

  tags {
    Name = "SSH out from bastion"
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
