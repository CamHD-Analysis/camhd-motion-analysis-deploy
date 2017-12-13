## Digital ocean connection set in a non-version-controlled .tf file

# Create a web server
resource "digitalocean_droplet" "example1" {
  image = "ubuntu-16-04-x64"
  name = "tf-example1"
  region = "nyc1"
  size = "512mb"
  ipv6 = true
  ssh_keys = [ "67:be:13:fc:a6:57:ba:77:50:c5:68:2b:3c:a2:1b:5a" ]

  provisioner "local-exec" {
    command = "sleep 30 && echo \"[webserver]\n${digitalocean_droplet.example1.ipv4_address} ansible_connection=ssh ansible_ssh_user=root\" > inventory && ansible-playbook -i inventory playbook.yml"
  }
}

resource "digitalocean_floating_ip" "cache" {
  droplet_id = "${digitalocean_droplet.example1.id}"
  region     = "${digitalocean_droplet.example1.region}"
}

output "address_web" {
  value = "${digitalocean_droplet.example1.ipv4_address}"
}
