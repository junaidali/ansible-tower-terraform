# -- root/outputs.tf
output "Tower Public IP(s)" {
    value = "${join(", ", module.compute.tower_ips)}"
}

output "Tower Admin Password" {
    value = "${module.compute.tower_admin_password}"
}
output "Private Inventory IP(s)" {
    value = "${join(", ", module.compute.private_inventory_ips)}"
}

output "Public Inventory IP(s)" {
    value = "${join(", ", module.compute.public_inventory_ips)}"
}

output "Public Windows Inventory IP(s)" {
    value = "${join(", ", module.compute.win_public_inventory_ips)}"
}