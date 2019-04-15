# -- root/main.tf

provider "aws" {}

module "network" {
    source = "./modules/network"
    tag_prefix = "${var.tag_prefix}"
    vpc_cidr = "${var.vpc_cidr}"
    public_cidrs = "${var.public_cidrs}"
}