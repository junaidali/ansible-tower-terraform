# --- compute/main.tf
data "aws_ami" "centos_server" {
    most_recent = true
    owners = ["aws-marketplace"]
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name = "name"
        values = ["CentOS Linux 7 x86_64 HVM EBS *"]
    }
    filter {
        name = "owner-id"
        values = ["679593333241"]
    }
}

resource "aws_key_pair" "ssh_auth" {
    key_name = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "tower_server" {
    count = "${var.tower_server_count}"
    instance_type = "${var.instance_type}"
    ami = "${data.aws_ami.centos_server.id}"
    key_name = "${aws_key_pair.ssh_auth.id}"
    vpc_security_group_ids = ["${var.tower_sg}"]
    subnet_id = "${var.public_subnet}"
    root_block_device = {
        volume_size = "${var.tower_root_partition_size}"
    }
    tags = {
        Name = "${var.tag_prefix}-tower-${count.index + 1}"
    }

}