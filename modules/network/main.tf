# --- network/main.tf
data "aws_availability_zones" "available" {}

resource "aws_vpc" "sja_vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    assign_generated_ipv6_cidr_block = true
    tags = {
        Name = "${var.tag_prefix}-vpc"
    }
}