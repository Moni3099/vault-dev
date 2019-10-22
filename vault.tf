provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}

//SonarQube Instance
resource "google_compute_address" "sonarqubeip" {
  name   = "${var.sonarqube_instance_ip_name}"
  region = "${var.sonarqube_instance_ip_region}"
}


resource "google_compute_instance" "sonarqube" {
  name         = "${var.instance_name}"
  machine_type = "n1-standard-2"
  zone         = "us-east1-b"

  tags = ["name", "vault", "http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  #scratch_disk {
  #}

  network_interface {
    network    = "${var.sonarvpc}"
    subnetwork = "${var.sonarsub}"
    access_config {
      // Ephemeral IP
      nat_ip = "${google_compute_address.sonarqubeip.address}"
    }
  }
  metadata = {
    name = "vault"
  }

  metadata_startup_script = "sudo apt-get update -y;sudo apt-get install git -y; sudo git clone https://github.com/Diksha86/vault-dev.git; cd /vault; sudo chmod 777 /vault/*; sudo sh vault.sh"
}
