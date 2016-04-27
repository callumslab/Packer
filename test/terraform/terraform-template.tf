provider "aws" {
    access_key = ""
    secret_key = ""
    region = "eu-west-1"
}

resource "aws_instance" "packerimage" {
    ami = ""
    instance_type = "t2.small"
}