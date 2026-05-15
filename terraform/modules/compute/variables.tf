variable "vpc_id" {}

variable "public_subnet_id" {}

variable "ami_id" {
  default = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  default = "t2.micro"
}