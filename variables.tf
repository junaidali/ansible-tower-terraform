# -- root/variables.tf
variable "aws_region" {}
variable "tag_prefix" {}

# -- network
variable "vpc_cidr" {}
variable "public_cidrs" {
    type = "list"
}
