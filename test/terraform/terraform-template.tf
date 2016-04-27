provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "eu-west-1"
}

resource "aws_instance" "packerimage" {
    ami = "ami-c38808b0"
    instance_type = "t2.small"
}