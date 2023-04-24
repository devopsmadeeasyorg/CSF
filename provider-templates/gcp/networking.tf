resource "google_compute_network" "myvpc" {
  name                    = "myvpc"
  auto_create_subnetworks = "false"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "mysubnet" {
  name          = "mysubnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-west2"
  network       = google_compute_network.myvpc.id
}

# proxy-only subnet
resource "google_compute_subnetwork" "myproxysubnet" {
  name          = "myproxysubnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-west2"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.myvpc.id
}



resource "google_compute_address" "static" {
  count = 2
  name = "staticip-${count.index + 1}"
  region = "us-west2"
  depends_on = [ google_compute_firewall.myfw ]
}