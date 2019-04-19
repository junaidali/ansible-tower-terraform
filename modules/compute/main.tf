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

data "aws_ami" "inventory_win_node" {
    most_recent = true
    owners = ["801119661308"]
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "name"
        values = ["Windows_Server-2019-English-Full-Base*"]
    }
}
resource "random_string" "admin_password" {
    length = 16
    special = false
}

resource "random_string" "database_password" {
    length = 16
    special = false
}

resource "random_string" "rabbitmq_password" {
    length = 16
    special = false
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

resource "null_resource" "tower_server" {
    triggers {
        public_ip = "${aws_instance.tower_server.public_ip}"
    }

    connection {
        type = "ssh"
        host = "${aws_instance.tower_server.public_ip}"
        user = "ubuntu"
        agent = true
    }

    provisioner "local-exec" {
        command = "echo ANSIBLE_TOWER_VERSION='${var.tower_version}' > secrets.txt; echo ADMIN_PASSWORD='${random_string.admin_password.result}' >> secrets.txt; echo DB_PASSWORD='${random_string.database_password.result}' >> secrets.txt; echo RABBITMQ_PASSWORD='${random_string.rabbitmq_password.result}' >> secrets.txt"
        working_dir = "./modules/compute/files/"
    }
    provisioner "file" {
        source = "modules/compute/files/ansible-tower.sh"
        destination = "/tmp/ansible-tower.sh"
    }

    provisioner "file" {
        source = "modules/compute/files/secrets.txt"
        destination = "/tmp/secrets.txt"
    }
    
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/ansible-tower.sh",
            "cd /tmp/",
            "sudo /tmp/ansible-tower.sh > /tmp/ansible-tower.log"
        ]
    }
}

resource "aws_instance" "inventory_nodes_public" {
    count = "${var.public_nodes_count}"
    instance_type = "${var.node_instance_type}"
    ami = "${data.aws_ami.inventory_node.id}"
    key_name = "${aws_key_pair.ssh_auth.id}"
    vpc_security_group_ids = ["${var.inventory_node_sg}"]
    subnet_id = "${var.public_subnet}"
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
    tags = {
        Name = "${var.name_tag_prefix}-tower-inventory-node-private-${count.index + 1}",
        Owner = "${var.aws_resource_owner_name}"
    }
}

resource "aws_instance" "win_inventory_nodes_public" {
    count = "${var.public_win_nodes_count}"
    instance_type = "${var.win_node_instance_type}"
    ami = "${data.aws_ami.inventory_win_node.id}"
    key_name = "${aws_key_pair.ssh_auth.id}"
    vpc_security_group_ids = ["${var.inventory_win_node_sg}"]
    subnet_id = "${var.public_subnet}"
    tags = {
        Name = "${var.name_tag_prefix}-tower-inventory-win-node-public-${count.index + 1}",
        Owner = "${var.aws_resource_owner_name}"
    }
}