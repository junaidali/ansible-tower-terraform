# -- root/variables.tf
variable "aws_region" {}
variable "name_tag_prefix" {}
variable "aws_resource_owner_name" {}

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
variable "tower_instance_type" {}
variable "tower_root_partition_size" {}
variable "public_nodes_count" {}
variable "private_nodes_count" {}
variable "node_instance_type" {}