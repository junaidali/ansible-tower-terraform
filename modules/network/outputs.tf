# --- network/outputs.tf
output "public_subnet" {
    value = "${aws_subnet.public_subnet.id}"
}

output "private_subnet" {
    value = "${aws_subnet.private_subnet.id}"
}
output "tower_sg" {
    value = "${aws_security_group.tower.id}"
}

output "inventory_node_sg" {
  value = "${aws_security_group.inventory_node_sg.id}"
}

output "inventory_win_node_sg" {
    value = "${aws_security_group.inventory_win_node_sg.id}"
}