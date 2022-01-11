provider "google" {
#    credentials = file("t2creds.json")
    project = "ebrown-test"
    region = "us-west1"
}

resource "random_id" "instance_id" {
    byte_length = 8
}

resource "google_compute_instance" "default" {
    name = "flask-vm-${random_id.instance_id.hex}"
    machine_type = "f1-micro"
    zone = "us-west1-a"

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-9"
        }
    }

    metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

    network_interface {
        network = "default"

        access_config {

        }
    }

#    metadata = {
#        ssh-keys= "ebrown:${file("id_rsa.pub")}"
#    }
}

output "ip" {
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_firewall" "default" {
 name    = "flask-app-firewall"
 network = "default"

 allow {
   protocol = "tcp"
   ports    = ["5000"]
 }

 source_ranges = ["0.0.0.0/0"]
}
