# -- root/outputs.tf
output "Tower Public IP(s)" {
    value = "${join(", ", module.compute.tower_ips)}"
}