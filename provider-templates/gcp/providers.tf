terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.20.0"
    }
  }
}

provider "google" {
  # credentials = "${file("~/Downloads/gcp_cred.json")}" # to hard code credentials file
  #credentials = file("*.json") # to hard code credentials file
  project = "${var.myproject}"
  region = "${var.myregion}"
}

#resource "google_project" "my_project" {
#  name       = "myroject"
#  project_id = "myprojectid"
#}

