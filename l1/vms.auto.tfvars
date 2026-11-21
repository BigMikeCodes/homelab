# Cloud images available to VMs. Add an entry here, then reference its key
# from a VM's `image` attribute.
images = {
  debian-13 = {
    url       = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
    file_name = "debian-13-genericcloud-amd64.qcow2"
  }
  ubuntu-24-04 = {
    url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
    file_name = "ubuntu-24.04-server-cloudimg-amd64.qcow2"
  }
}

# VMs. To add one, copy a block, give it a new key and `tofu apply`.
# Every attribute except `image` is optional; see variables.tf for defaults.
vms = {
  test-vm = {
    image        = "debian-13"
    cores        = 2
    memory_mb    = 2048
    disk_size_gb = 20
    tags         = ["test"]

    username = "admin"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXKOIH1AAl9nNcp1uPek9ubS+sXhYwmIB2Hgfma+aL7",
    ]
  }

  # example-static = {
  #   vm_id        = 200
  #   image        = "ubuntu-24-04"
  #   cores        = 4
  #   memory_mb    = 4096
  #   disk_size_gb = 40
  #   ipv4_address = "192.168.1.50/24"
  #   ipv4_gateway = "192.168.1.1"
  #   tags         = ["app"]
  #   username     = "deploy"
  #   ssh_public_keys = ["ssh-ed25519 AAAA... you@workstation"]
  # }
}
