provider "google" {
#    credentials = file("t2creds.json")
    project = "ebrown-test"
    region = "us-west1"
}

resource "google_compute_instance" "default" {
    name = var.instance_name
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

    metadata = {
        ssh-keys="dev:${var.user_pub_key}\n"
#        ssh-keys="dev:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCeJkVih2fq7OKwMiD8XFAkF7uA62jZbZX9lKuHwGWz0wz7pqw6wSM/BtMe+Qv/pv/3kQwd0elW34W/3ARYTcChk/yC6VB6zpcnXHCuJagkVcOSQPs9AbOym+/E/SUqKs3RCHVjhh1fJuvfiEgGTb9IEOi2PueletTTwNT1LfqcNWXI3hxpCPqp8uHcU5lxc5K3NNQoV3wFnEddfHCmOys9wbBIx/eNyEG8S2PmT1kTLWM4yXYLyPG+OeOrbSxgOfuebYsm5kVB8mQuDOG34pOhxINlm4IbBFpKt9P/L3ws8IZkJQ8a3suwNBzkgpx4oQmlrQmjrVB6anS7WJVdd0YxBBH2T43pZXeCyE8ysdg7BOBmruNIvARJZE2PM4jqUu3YC9+0AHYe85HH/Xh2LXf0VkK6zMPI3QDo3Ax2cPXk+DucqTTA+oTuhEpICzAhUHSkj3OHsZJZ3ASKE08Nl0gWFd5so5Ei8KPLxoFC9okhS1g8yf2W0CxFpGaKgN/ucfs="
#        ssh-keys= "ebrown:${file("id_rsa.pub")}"
    }
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
