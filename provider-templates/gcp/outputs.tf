output "bastionhost_public_ip" {
  value = "ssh gcp-user@${google_compute_instance.bastionhost.network_interface.0.access_config.0.nat_ip}"
}

output "LB_public_ip" {
  value = "ssh gcp-user@${google_compute_address.default.id}"
}

# output "appserver1_public_ip" {
#   value = "ssh gcp-user@${google_compute_instance.appservers[0].network_interface.0.access_config.0.nat_ip}"
# }

# output "appserver2_public_ip" {
#   value = "ssh gcp-user@${google_compute_instance.appservers[1].network_interface.0.access_config.0.nat_ip}"
# }
