provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    token = "${var.token}"
    region = "${var.region}"
}

resource "aws_instance" "packerimage" {
    ami = "${var.packer_ami}"
    instance_type = "t2.small"
    key_name = "${var.keypair}"
    subnet_id = "${var.subnet_id}"
    vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
    tags {
        Name = "Terraform Builder"
    }
}