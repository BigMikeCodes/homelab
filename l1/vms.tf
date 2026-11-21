module "vm" {
  source   = "./modules/vm"
  for_each = var.vms

  name        = coalesce(each.value.name, each.key)
  vm_id       = each.value.vm_id
  description = each.value.description
  tags        = each.value.tags
  node_name   = var.node_name

  cores        = each.value.cores
  memory_mb    = each.value.memory_mb
  disk_size_gb = each.value.disk_size_gb
  datastore_id = coalesce(each.value.datastore_id, var.vm_datastore_id)
  image_id     = proxmox_download_file.image[each.value.image].id

  bridge       = coalesce(each.value.bridge, var.default_bridge)
  vlan_id      = each.value.vlan_id
  ipv4_address = each.value.ipv4_address
  ipv4_gateway = each.value.ipv4_gateway
  dns_servers  = var.dns_servers

  username            = coalesce(each.value.username, var.default_username)
  ssh_public_keys     = each.value.ssh_public_keys != null ? each.value.ssh_public_keys : var.ssh_public_keys
  vendor_data_file_id = proxmox_virtual_environment_file.vendor_data.id

  on_boot = each.value.on_boot
  started = each.value.started
}
