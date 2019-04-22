# --- compute/outputs.tf
output "tower_ips" {
  value = "${aws_instance.tower_server.*.public_ip}"
}

output "public_inventory_ips" {
  value = "${aws_instance.inventory_nodes_public.*.public_ip}"
}

output "private_inventory_ips" {
  value = "${aws_instance.inventory_nodes_private.*.private_ip}"
}

output "tower_admin_password" {
  value = "${random_string.admin_password.result}"
}

output "win_public_inventory_ips" {
  value = "${aws_instance.win_inventory_nodes_public.*.public_ip}"
}

output "win_private_inventory_ips" {
  value = "${aws_instance.win_inventory_nodes_private.*.private_ip}"
}