# -- root/main.tf

provider "aws" {
    region = "${var.aws_region}"
}

module "network" {
    source = "./modules/network"
    tag_prefix = "${var.tag_prefix}"
    vpc_cidr = "${var.vpc_cidr}"
    public_cidr = "${var.public_cidr}"
    private_cidr = "${var.private_cidr}"
    domainname = "${var.domainname}"
}