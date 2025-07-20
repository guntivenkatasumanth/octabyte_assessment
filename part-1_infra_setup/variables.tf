variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI named profile"
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
