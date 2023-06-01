### Instance template

# resource "google_compute_instance_template" "myit" {
#   name        = "webserver-template"
#   instance_description = "description assigned to instances"
#   machine_type         = "e2-medium"
#   can_ip_forward       = false
#   disk {
#     source_image      = "debian-11-bullseye-v20220519"
#     auto_delete       = true
#     boot              = true
#     disk_type = "pd-balanced"
#   }
#   network_interface {
#     subnetwork = google_compute_subnetwork.mysubnet.id
#   }
# }

### Instance group
resource "google_compute_instance_group" "myig" {
  name        = "terraform-webservers"
  description = "Terraform test instance group"

  instances = [
    google_compute_instance.appservers[0].id,
    google_compute_instance.appservers[1].id
  ]

  named_port {
    name = "tcp"
    port = "8000"
  }

  named_port {
    name = "http"
    port = "8000"
  }

  zone = "us-west2-a"
}

### Create Load balancer
resource "google_compute_address" "default" {
  name = "website-ip-1"
  region = "us-west2"
  network_tier = "STANDARD"
}

resource "google_compute_forwarding_rule" "default" {
 # provider = google-beta
  depends_on = [google_compute_subnetwork.myproxysubnet]
  name   = "website-forwarding-rule"
  region = "us-west2"
  ip_protocol           = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.myvpc.id
  #subnetwork = google_compute_subnetwork.mysubnet.id
  #subnetwork = google_compute_subnetwork.myproxysubnet.id
  ip_address            = google_compute_address.default.id
  network_tier          = "STANDARD"
}

resource "google_compute_region_target_http_proxy" "default" {
  #provider = google-beta
  region  = "us-west2"
  name    = "website-proxy"
  
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_region_url_map" "default" {
  #provider = google-beta
  region          = "us-west2"
  name            = "website-map"
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_backend_service" "default" {
  #provider = google-beta

  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_instance_group.myig.id
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }

  region      = "us-west2"
  name        = "website-backend"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_region_health_check.default.id]
}

resource "google_compute_region_health_check" "default" {
  depends_on = [google_compute_firewall.myfw]
 # provider = google-beta

  region = "us-west2"
  name   = "website-hc"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

