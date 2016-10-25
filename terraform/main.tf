resource "aws_vpc" "bless_example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "default" {
  vpc_id     = "${aws_vpc.bless_example.id}"
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.bless_example.id}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.bless_example.id}"
  route  = {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "default" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}


data "template_file" "bastion_user_data" {
  template = "${file("user-data/cloud-init-bastion.yaml")}"
  vars {
    region         = "${var.region}"
    bless_function = "${var.bless_function}"
    bless_user     = "${var.bless_user}"
  }
}

data "template_file" "app_server_user_data" {
  template = "${file("user-data/cloud-init-app-server.yaml")}"
  vars {
    ca_keys = "${join("\n", var.ssh_ca_keys)}"
  }
}

resource "aws_instance" "bastion" {
  instance_type               = "t2.micro"
  ami                         = "${var.ami}"
  subnet_id                   = "${aws_subnet.default.id}"
  private_ip                  = "10.0.1.4"
  associate_public_ip_address = true,
  iam_instance_profile        = "${aws_iam_instance_profile.call_bless_instance_profile.id}"
  user_data                   = "${data.template_file.bastion_user_data.rendered}"

  vpc_security_group_ids      = [
    "${aws_security_group.ssh_from_internet.id}",
    "${aws_security_group.expected_internet_traffic.id}",
  ]
}

resource "aws_instance" "app_server" {
  instance_type               = "t2.micro"
  ami                         = "${var.ami}"
  subnet_id                   = "${aws_subnet.default.id}"
  private_ip                  = "10.0.1.5"
  associate_public_ip_address = true,
  user_data                   = "${data.template_file.app_server_user_data.rendered}"

  vpc_security_group_ids      = [
    "${aws_security_group.ssh_from_bastion.id}",
    "${aws_security_group.expected_internet_traffic.id}"
  ]
}
