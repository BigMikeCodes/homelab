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

vms = {
  
  node-1 = {
    image        = "debian-13"
    cores        = 2
    memory_mb    = 2048
    disk_size_gb = 20
    tags         = ["node"]

    username = "admin"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXKOIH1AAl9nNcp1uPek9ubS+sXhYwmIB2Hgfma+aL7",
    ]
  }
  
  node-2 = {
    image        = "debian-13"
    cores        = 2
    memory_mb    = 2048
    disk_size_gb = 20
    tags         = ["node"]

    username = "admin"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXKOIH1AAl9nNcp1uPek9ubS+sXhYwmIB2Hgfma+aL7",
    ]
  }

  node-3 = {
    image        = "debian-13"
    cores        = 2
    memory_mb    = 2048
    disk_size_gb = 20
    tags         = ["node"]

    username = "admin"
    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEXKOIH1AAl9nNcp1uPek9ubS+sXhYwmIB2Hgfma+aL7",
    ]
  }
  
}
