## Digital ocean connection set in a non-version-controlled .tf file

# Create a web server
resource "digitalocean_droplet" "dockerhost" {
  image = "ubuntu-16-04-x64"
  name = "dockerhost"
  region = "nyc1"
  size = "512mb"
  ipv6 = true
  ssh_keys = [ "67:be:13:fc:a6:57:ba:77:50:c5:68:2b:3c:a2:1b:5a" ]

  provisioner "remote-exec" {
    inline = [
      "apt-get -y install python python-simplejson"
    ]
  }

  provisioner "local-exec" {
    command = "sleep 30 && echo \"[dockerhost]\n${digitalocean_droplet.dockerhost.ipv4_address} ansible_connection=ssh ansible_ssh_user=root\" > inventory && ansible-playbook -i inventory playbook.yml"
  }
}

resource "digitalocean_floating_ip" "cache" {
  droplet_id = "${digitalocean_droplet.dockerhost.id}"
  region     = "${digitalocean_droplet.dockerhost.region}"
}

output "address_web" {
  value = "${digitalocean_droplet.dockerhost.ipv4_address}"
}
