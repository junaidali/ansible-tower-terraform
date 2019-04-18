# --- compute/main.tf
data "aws_ami" "tower_server" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
}

data "aws_ami" "inventory_node" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
}

resource "aws_key_pair" "ssh_auth" {
    key_name = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "tower_server" {
    count = "${var.tower_server_count}"
    instance_type = "${var.tower_instance_type}"
    ami = "${data.aws_ami.tower_server.id}"
    key_name = "${aws_key_pair.ssh_auth.id}"
    vpc_security_group_ids = ["${var.tower_sg}"]
    subnet_id = "${var.public_subnet}"
    root_block_device = {
        volume_size = "${var.tower_root_partition_size}"
    }
    tags = {
        Name = "${var.name_tag_prefix}-tower-${count.index + 1}",
        Owner = "${var.aws_resource_owner_name}"
    }
}

resource "aws_instance" "inventory_nodes_public" {
    count = "${var.public_nodes_count}"
    instance_type = "${var.node_instance_type}"
    ami = "${data.aws_ami.inventory_node.id}"
    key_name = "${aws_key_pair.ssh_auth.id}"
    vpc_security_group_ids = ["${var.inventory_node_sg}"]
    subnet_id = "${var.public_subnet}"
    root_block_device = {
        volume_size = "${var.tower_root_partition_size}"
    }
    tags = {
        Name = "${var.name_tag_prefix}-tower-inventory-node-public-${count.index + 1}",
        Owner = "${var.aws_resource_owner_name}"
    }
}

resource "aws_instance" "inventory_nodes_private" {
    count = "${var.private_nodes_count}"
    instance_type = "${var.node_instance_type}"
    ami = "${data.aws_ami.inventory_node.id}"
    key_name = "${aws_key_pair.ssh_auth.id}"
    vpc_security_group_ids = ["${var.inventory_node_sg}"]
    subnet_id = "${var.private_subnet}"
    root_block_device = {
        volume_size = "${var.tower_root_partition_size}"
    }
    tags = {
        Name = "${var.name_tag_prefix}-tower-inventory-node-private-${count.index + 1}",
        Owner = "${var.aws_resource_owner_name}"
    }
}