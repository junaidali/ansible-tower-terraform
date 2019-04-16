# --- network/outputs.tf
output "public_subnet" {
    value = "${aws_subnet.public_subnet.id}"
}

output "tower_sg" {
    value = "${aws_security_group.tower.id}"
}