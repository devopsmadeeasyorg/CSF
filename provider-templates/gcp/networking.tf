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



# resource "google_compute_address" "static" {
#   count = 2
#   name = "staticip-${count.index + 1}"
#   region = "us-west2"
#   depends_on = [ google_compute_firewall.myfw ]
# }

resource "google_compute_address" "bastionpip" {
  name = "bastionpip"
  region = "us-west2"
  depends_on = [ google_compute_firewall.myfw ]
}





## Create Cloud Router

resource "google_compute_router" "router" {
  # project = var.project_name
  name    = "nat-router"
  network       = google_compute_network.myvpc.id
  region  = "us-west2"
}

## Create Nat Gateway

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region        = "us-west2"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}