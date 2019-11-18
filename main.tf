provider "aws" {
  region  = "ap-southeast-1"
  version = "~> 2.24"
}

module "vpc" {
  source = "Modules/vpc"
}

module "ecs" {
  source = "Modules/ecs"
}
