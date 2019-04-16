# --- compute/outputs.tf
output "tower_ips" {
  value = "${aws_instance.tower_server.*.public_ip}"
}
