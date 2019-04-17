# -- root/main.tf

provider "aws" {
    region = "${var.aws_region}"
}

module "network" {
    source = "./modules/network"
    name_tag_prefix = "${var.name_tag_prefix}"
    aws_resource_owner_name = "${var.aws_resource_owner_name}"
    vpc_cidr = "${var.vpc_cidr}"
    public_cidr = "${var.public_cidr}"
    private_cidr = "${var.private_cidr}"
    domainname = "${var.domainname}"
    accessip = "${var.accessip}"
}

module "compute" {
    source = "./modules/compute"
    name_tag_prefix = "${var.name_tag_prefix}"
    aws_resource_owner_name = "${var.aws_resource_owner_name}"
    key_name = "${var.key_name}"
    public_key_path = "${var.public_key_path}"
    tower_server_count = "${var.tower_server_count}"
    instance_type = "${var.instance_type}"
    tower_sg = "${module.network.tower_sg}"
    public_subnet = "${module.network.public_subnet}"
    tower_root_partition_size = "${var.tower_root_partition_size}"
}