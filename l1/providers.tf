provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure

  # A few operations (e.g. uploading cloud-init snippets) are not available
  # via the Proxmox API and are done over SSH instead. Keys are taken from
  # your local ssh-agent.
  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }
}
