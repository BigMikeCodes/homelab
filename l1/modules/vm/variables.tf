variable "name" {
  description = "VM name (also used as the hostname by cloud-init)."
  type        = string
}

variable "vm_id" {
  description = "Proxmox VM ID. Null lets Proxmox pick the next free ID."
  type        = number
  default     = null
}

variable "description" {
  type    = string
  default = "Managed by OpenTofu"
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "node_name" {
  type = string
}

variable "cores" {
  type    = number
  default = 2
}

variable "cpu_type" {
  description = "CPU type. 'host' gives best performance on a single-node setup."
  type        = string
  default     = "host"
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "disk_size_gb" {
  description = "Boot disk size. Must be >= the cloud image's virtual size."
  type        = number
  default     = 20
}

variable "datastore_id" {
  description = "Datastore for the boot disk and cloud-init drive."
  type        = string
}

variable "image_id" {
  description = "ID of a downloaded image (content type 'import') to use as the boot disk."
  type        = string
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "vlan_id" {
  type    = number
  default = null
}

variable "ipv4_address" {
  description = "\"dhcp\" or a CIDR address such as 192.168.1.50/24."
  type        = string
  default     = "dhcp"
}

variable "ipv4_gateway" {
  type    = string
  default = null
}

variable "dns_servers" {
  type    = list(string)
  default = []
}

variable "username" {
  type = string
}

variable "ssh_public_keys" {
  type    = list(string)
  default = []
}

variable "vendor_data_file_id" {
  description = "Optional cloud-init vendor-data snippet ID."
  type        = string
  default     = null
}

variable "on_boot" {
  type    = bool
  default = true
}

variable "started" {
  type    = bool
  default = true
}
