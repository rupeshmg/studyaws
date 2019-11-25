data "aws_region" "current" {}

variable "anywhere" {
  default = "0.0.0.0/0"
}

variable "aws_vpc_default_id" {}
variable "aws_sg_id" {}
variable "aws_subnet_dgsubnet1_id" {}

variable "aws_subnet_dgsubnet2_id" {}
