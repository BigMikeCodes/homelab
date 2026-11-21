# Cloud images are downloaded once onto the node and shared by every VM that
# references them. New VMs import a copy of the image as their boot disk.
resource "proxmox_download_file" "image" {
  for_each = var.images

  node_name    = var.node_name
  datastore_id = var.image_datastore_id
  content_type = "import"

  url                = each.value.url
  file_name          = each.value.file_name
  checksum           = each.value.checksum
  checksum_algorithm = each.value.checksum_algorithm

  # The "latest" image URLs change upstream over time. Don't re-download on
  # every change; bump the image explicitly when you want a newer base.
  overwrite = false
}

# Shared cloud-init vendor-data: common packages (incl. the QEMU guest agent, so
# Proxmox and OpenTofu outputs can see each VM's IP) and SSH hardening.
# Users/keys are per VM, via `user_account` in the vm module.
resource "proxmox_virtual_environment_file" "vendor_data" {
  node_name    = var.node_name
  datastore_id = var.image_datastore_id
  content_type = "snippets"

  source_raw {
    file_name = "tofu-vendor-data.yaml"
    data      = file("${path.module}/cloud-init/vendor-data.yaml")
  }
}
