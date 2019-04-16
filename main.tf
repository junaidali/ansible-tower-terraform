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
    accessip = "${var.accessip}"
}

module "compute" {
    source = "./modules/compute"
    tag_prefix = "${var.tag_prefix}"
    key_name = "${var.key_name}"
    public_key_path = "${var.public_key_path}"
    tower_server_count = "${var.tower_server_count}"
    instance_type = "${var.instance_type}"
    tower_sg = "${module.network.tower_sg}"
    public_subnet = "${module.network.public_subnet}"
    tower_root_partition_size = "${var.tower_root_partition_size}"
}