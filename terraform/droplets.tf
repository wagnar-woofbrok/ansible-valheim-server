# https://docs.digitalocean.com/reference/terraform/reference/resources/droplet/
# https://docs.digitalocean.com/reference/api/api-reference/#tag/Sizes

resource "digitalocean_droplet" "valheim" {
  count  = 1
  image  = "ubuntu-20-04-x64"
  name   = "valheim-game-server"
  region = "sfo1"
  size   = "s-2vcpu-4gb"

  ssh_keys = [
      data.digitalocean_ssh_key.pureos.id
  ]

  provisioner "remote-exec" {
    inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

    connection {
        host        = self.ipv4_address
        type        = "ssh"
        user        = "root"
        private_key = file(var.pvt_key)
    }
  }


  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' playbook.yml"
  }
}

output "droplet_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.valheim:
    droplet.name => droplet.ipv4_address
  }
}