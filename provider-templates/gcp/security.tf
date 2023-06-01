resource "google_compute_firewall" "myfw" {
  name    = "myfw"
  network = google_compute_network.myvpc.name
  allow {
    protocol = "tcp"
    ports    = ["22","80","443", "8000"]
  }
source_ranges = ["0.0.0.0/0"]
}