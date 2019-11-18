data "aws_region" "current" {}

variable "anywhere" {
  default = "0.0.0.0/0"
}
