output "appserver1_public_ip" {
  value = google_compute_instance.appservers[0].network_interface.0.access_config.0.nat_ip
}

output "appserver2_public_ip" {
  value = google_compute_instance.appservers[1].network_interface.0.access_config.0.nat_ip
}
