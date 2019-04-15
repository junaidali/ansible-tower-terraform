# -- root/variables.tf
variable "aws_region" {}
variable "tag_prefix" {}

# -- network
variable "vpc_cidr" {}
variable "public_cidr" {}
variable "private_cidr" {}
variable "domainname" {}