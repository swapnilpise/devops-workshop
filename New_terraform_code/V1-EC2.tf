provider "aws" {
    region = "us-east-1"

}

resource "aws_instance" "demo-server" {
    ami = "ami-06b21ccaeff8cd686"
    instance_type = "t2.micro"
    key_name = "ddp"
    }