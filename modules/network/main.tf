# --- network/main.tf
data "aws_availability_zones" "available" {}

# dhcp options set
resource "aws_vpc_dhcp_options" "dhcpopts" {
    domain_name = "${var.domainname}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags = {
        Name = "${var.tag_prefix}-dhcp-options"
    }
}

# vpc
resource "aws_vpc" "vpc1" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    assign_generated_ipv6_cidr_block = true
    tags = {
        Name = "${var.tag_prefix}-vpc"
    }
}

# set dhcp option set
resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.vpc1.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dhcpopts.id}"
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc1.id}"
    tags = {
        Name = "${var.tag_prefix}-igw"
    }
}

# public route table
resource "aws_route_table" "public_rt" {
    vpc_id = "${aws_vpc.vpc1.id}"

    # default ipv4 route
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    # default ipv6 route
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags = {
        Name = "${var.tag_prefix}-public-rt"
    }
}

# public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id  = "${aws_vpc.vpc1.id}"
    cidr_block = "${var.public_cidr}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags = {
        Name = "${var.tag_prefix}-public-subnet"
    }
}

# associate route table to public subnet
resource "aws_route_table_association" "public_rt_assoc" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public_rt.id}"
}

# default vpc route table
resource "aws_default_route_table" "vpc_default_rt" {
    default_route_table_id = "${aws_vpc.vpc1.default_route_table_id}"
    tags = {
        Name = "${var.tag_prefix}-default-rt"
    }
}
# private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.vpc1.id}"
    cidr_block = "${var.private_cidr}"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"

    tags = {
        Name = "${var.tag_prefix}-private-subnet"
    }
}
/*
# elastic IP
resource "aws_eip" "natgw_eip" {
    tags = {
        Name = "${var.tag_prefix}-nat-gateway-eip"
    }
}
# nat gateway
resource "aws_nat_gateway" "natgw" {
    allocation_id = "${aws_eip.natgw_eip.id}"
    subnet_id = "${aws_subnet.private_subnet.id}"

    depends_on = ["aws_internet_gateway.igw"]
}
# private route table
resource "aws_route_table" "private_rt" {
    vpc_id = "${aws_vpc.vpc1.id}"

    # default ipv4 route
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.natgw.id}"
    }
    # default ipv6 route
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = "${aws_nat_gateway.natgw.id}"
    }

    tags = {
        Name = "${var.tag_prefix}-public-rt"
    }
}
*/

resource "aws_security_group" "tower" {
    name = "${var.tag_prefix}-tower_sg"
    description = "Allows Tower Communications"
    vpc_id = "${aws_vpc.vpc1.id}"
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.accessip}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "${var.tag_prefix}-tower_sg"
    }
}