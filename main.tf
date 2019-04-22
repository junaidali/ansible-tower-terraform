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
    tower_version = "${var.tower_version}"
    tower_server_count = "${var.tower_server_count}"
    tower_instance_type = "${var.tower_instance_type}"
    node_instance_type = "${var.node_instance_type}"
    tower_sg = "${module.network.tower_sg}"
    inventory_node_sg = "${module.network.inventory_node_sg}"
    public_subnet = "${module.network.public_subnet}"
    private_subnet = "${module.network.private_subnet}"
    tower_root_partition_size = "${var.tower_root_partition_size}"
    public_nodes_count = "${var.public_nodes_count}"
    private_nodes_count = "${var.private_nodes_count}"
    public_win_nodes_count = "${var.public_win_nodes_count}"
    private_win_nodes_count = "${var.private_win_nodes_count}"
    inventory_win_node_sg = "${module.network.inventory_win_node_sg}"
    win_node_instance_type = "${var.win_node_instance_type}"
}