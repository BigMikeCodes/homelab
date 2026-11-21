# L1: Proxmox with OpenTofu

This layer manages a single-node Proxmox VE server with [OpenTofu](https://opentofu.org) and the
[`bpg/proxmox`](https://search.opentofu.org/provider/bpg/proxmox/latest) provider.

```
l1/
├── versions.tf              # OpenTofu + provider version pins
├── providers.tf             # Proxmox provider (API token + SSH agent)
├── variables.tf             # All inputs, incl. the typed `images` and `vms` maps
├── images.tf                # Cloud images downloaded to the node + shared cloud-init snippet
├── vms.tf                   # One module instance per entry in `vms`
├── outputs.tf               # VM IDs and IPs
├── vms.auto.tfvars          # Images and VMs you want (committed)
├── terraform.tfvars.example # Connection details and secrets (copy to terraform.tfvars, git-ignored)
├── cloud-init/
│   └── vendor-data.yaml     # Installs qemu-guest-agent on every VM
└── modules/vm/              # Reusable VM module
```

## One-time setup on the Proxmox host

Run these commands as root on the Proxmox server, in its shell or over SSH.

```bash
# 1. Let the `local` storage hold importable disk images and cloud-init snippets
pvesm set local --content iso,vztmpl,backup,import,snippets

# 2. Create a dedicated user, role, and API token for OpenTofu
pveum user add tofu@pve --comment "OpenTofu"
pveum role add TofuProvisioner -privs "\
Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit \
Pool.Allocate Pool.Audit SDN.Use Sys.Audit Sys.Console Sys.Modify \
VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU \
VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options \
VM.GuestAgent.Audit VM.Migrate VM.PowerMgmt"
pveum aclmod / -user tofu@pve -role TofuProvisioner
pveum user token add tofu@pve tofu --privsep 0
```

Copy the token secret from the last command's output. It is shown only once.

> On Proxmox VE 8, `VM.GuestAgent.Audit` does not exist. Replace it with `VM.Monitor`.

```bash
# 3. From your workstation: allow key-based SSH as root (used for snippet uploads)
ssh-copy-id root@<proxmox-ip>
ssh-add -l   # make sure your key is loaded in ssh-agent
```

## Usage

```bash
cd l1
cp terraform.tfvars.example terraform.tfvars   # then edit it
tofu init
tofu plan
tofu apply
tofu output vms
```

The first apply downloads the cloud images to the node, which can take a few minutes. After
that, each VM boots, cloud-init installs the guest agent, and the VM's IP appears in
`tofu output vms`.

Log in with `ssh <default_username>@<ip>`, using one of the keys in `ssh_public_keys`.

## Adding a VM

Add an entry to `vms` in `vms.auto.tfvars`:

```hcl
vms = {
  test-vm = { image = "debian-13" }

  web-01 = {
    image        = "ubuntu-24-04"
    cores        = 4
    memory_mb    = 4096
    disk_size_gb = 40
    ipv4_address = "192.168.1.50/24"
    ipv4_gateway = "192.168.1.1"
    tags         = ["web"]
  }
}
```

Then run `tofu apply`. Every attribute except `image` is optional. See the `vms` variable in
`variables.tf` for the full list and the defaults.

To add a new base OS, add an entry to `images` and reference its key from a VM.

Removing an entry from `vms` **destroys** that VM. Always read the plan before applying.

## Notes

- **Provider resources.** VMs use `proxmox_virtual_environment_vm`, which is the stable,
  full-featured resource. The provider's newer `proxmox_vm` resource is still marked
  experimental. Images use `proxmox_download_file`, which replaces the deprecated
  `proxmox_virtual_environment_download_file`.
- **Image updates.** `overwrite = false` means upstream "latest" images are not downloaded
  again on every plan. To refresh an image, change its `file_name` (for example, add a date).
  Existing VMs are not affected, because the image is only used when a VM is created.
- **State.** State is stored locally in `terraform.tfstate` and is git-ignored. Back it up, or
  move to a remote backend later. OpenTofu can also
  [encrypt state](https://opentofu.org/docs/language/state/encryption/) natively.
- **Upgrading the provider.** Change the version in `versions.tf`, then run `tofu init -upgrade`.
