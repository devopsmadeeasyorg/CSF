resource "google_compute_instance" "appservers" {
  count = 2
  name         = "appserver-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = "us-west2-a"

  boot_disk {
    /* initialize_params {
      size  = "25"               
      type  = "pd-ssd"
      image = "debian-11-bullseye-v20220519"
    } */
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id
    access_config {
      // Ephemeral public IP
      nat_ip = google_compute_address.static[count.index].address
    }
}
metadata = {
  ssh-keys ="${var.mysshuser}:${var.mykey}"
}

 /*provisioner "remote-exec" {
    connection {
      host        = google_compute_address.static[count.index].address
      type        = "ssh"
      user        = "gcp-user"
      timeout     = "500s"
      private_key = file("~/.ssh/id_rsa")
    }
     inline = [
      "sudo apt update",

      "sudo apt install docker.io -y",

      "sudo usermod -aG docker $USER && sudo chmod 777 /var/run/docker.sock",
      
      "sudo git clone https://github.com/csp2022/CSP.git && cd CSP/utils/flask",

      "sudo docker image build -t flask .",

      "sudo docker run -d --name flask -p 5001:5001 flask"
        ] 
        inline =["sudo yum install git -y"]
  }*/
}

