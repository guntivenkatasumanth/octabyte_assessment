provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "octabyte-tf-state"
    key    = "infra/terraform.tfstate"
    region = "us-east-1"
  }
}