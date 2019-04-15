# -- network/variables.tf

variable "tag_prefix" {}
variable "vpc_cidr" {}
variable "public_cidrs" {
    type = "list"
}