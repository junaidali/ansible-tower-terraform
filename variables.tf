# -- root/variables.tf
variable "aws_region" {}
variable "tag_prefix" {}

# -- network
variable "vpc_cidr" {}
variable "public_cidr" {}
variable "private_cidr" {}
variable "domainname" {}
variable "accessip" {}

# -- compute
variable key_name {}
variable "public_key_path" {}
variable "tower_server_count" {}
variable "instance_type" {}
variable "tower_root_partition_size" {}