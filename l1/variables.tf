# --- Connection --------------------------------------------------------------

variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint, e.g. https://192.168.1.10:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token in the form 'user@realm!tokenid=secret'."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (the default Proxmox install uses a self-signed cert)."
  type        = bool
  default     = true
}

variable "proxmox_ssh_username" {
  description = "SSH user on the Proxmox node, used for operations the API can't do (snippet uploads)."
  type        = string
  default     = "tofu"
}

# --- Node / storage defaults -------------------------------------------------

variable "node_name" {
  description = "Name of the Proxmox node (see `hostname` on the server)."
  type        = string
  default     = "pve"
}

variable "image_datastore_id" {
  description = "Datastore for downloaded cloud images and snippets. Needs 'import' and 'snippets' content types enabled."
  type        = string
  default     = "local"
}

variable "vm_datastore_id" {
  description = "Default datastore for VM disks."
  type        = string
  default     = "local-lvm"
}

variable "default_bridge" {
  description = "Default network bridge for VMs."
  type        = string
  default     = "vmbr0"
}

# --- Defaults applied to every VM -------------------------------------------

# Per-VM `username` / `ssh_public_keys` in `vms` override these.

variable "default_username" {
  description = "User created by cloud-init on VMs that don't set `username`."
  type        = string
  default     = "admin"
}

variable "ssh_public_keys" {
  description = "SSH public keys for VMs that don't set `ssh_public_keys`."
  type        = list(string)
  default     = []
}

variable "dns_servers" {
  description = "DNS servers handed to VMs with static IPs. Empty = use DHCP-provided / image defaults."
  type        = list(string)
  default     = []
}

# --- Catalogue ---------------------------------------------------------------

variable "images" {
  description = "Cloud images to download onto the node. Keys are referenced by `vms[*].image`."
  type = map(object({
    url                = string
    file_name          = string
    checksum           = optional(string)
    checksum_algorithm = optional(string)
  }))
  default = {}
}

variable "vms" {
  description = "VMs to create. The map key is used as the VM name unless `name` is set."
  type = map(object({
    name            = optional(string)
    vm_id           = optional(number)
    description     = optional(string, "Managed by OpenTofu")
    tags            = optional(list(string), [])
    image           = string
    cores           = optional(number, 2)
    memory_mb       = optional(number, 2048)
    disk_size_gb    = optional(number, 20)
    datastore_id    = optional(string)
    bridge          = optional(string)
    vlan_id         = optional(number)
    ipv4_address    = optional(string, "dhcp") # "dhcp" or CIDR, e.g. "192.168.1.50/24"
    ipv4_gateway    = optional(string)
    username        = optional(string)       # falls back to default_username
    ssh_public_keys = optional(list(string)) # falls back to ssh_public_keys
    on_boot         = optional(bool, true)
    started         = optional(bool, true)
  }))
  default = {}

  validation {
    condition = alltrue([
      for vm in var.vms : vm.ipv4_address == "dhcp" || can(cidrhost(vm.ipv4_address, 0))
    ])
    error_message = "ipv4_address must be \"dhcp\" or a CIDR such as 192.168.1.50/24."
  }

  validation {
    condition = alltrue([
      for vm in var.vms : vm.ipv4_address == "dhcp" || vm.ipv4_gateway != null
    ])
    error_message = "ipv4_gateway is required when ipv4_address is static."
  }
}
