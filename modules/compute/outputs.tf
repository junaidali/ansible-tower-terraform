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

