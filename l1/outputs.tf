output "vms" {
  description = "Created VMs with their ID and reported IPv4 addresses."
  value = {
    for k, vm in module.vm : k => {
      id   = vm.id
      name = vm.name
      ipv4 = vm.ipv4_addresses
    }
  }
}
