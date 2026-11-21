resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name
  vm_id       = var.vm_id
  description = var.description
  tags        = sort(concat(["tofu"], var.tags))
  node_name   = var.node_name

  on_boot         = var.on_boot
  started         = var.started
  stop_on_destroy = true

  machine       = "q35"
  scsi_hardware = "virtio-scsi-single"

  operating_system {
    type = "l26"
  }

  cpu {
    cores = var.cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = true
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.datastore_id
    import_from  = var.image_id
    size         = var.disk_size_gb
    file_format  = "raw"
    iothread     = true
    discard      = "on"
    ssd          = true
  }

  network_device {
    bridge  = var.bridge
    vlan_id = var.vlan_id
    model   = "virtio"
  }

  # Many cloud images expect a serial console.
  serial_device {}

  initialization {
    datastore_id        = var.datastore_id
    vendor_data_file_id = var.vendor_data_file_id

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_address == "dhcp" ? null : var.ipv4_gateway
      }
    }

    dynamic "dns" {
      for_each = length(var.dns_servers) > 0 ? [1] : []
      content {
        servers = var.dns_servers
      }
    }

    user_account {
      username = var.username
      keys     = var.ssh_public_keys
    }
  }
}
