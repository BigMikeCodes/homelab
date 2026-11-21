# Homelab

Infrastructure for a single-node Proxmox VE homelab, organised in layers. Each layer builds on
the one below it and lives in its own directory with its own README.

| Layer | Directory | Purpose | Status |
|-------|-----------|---------|--------|
| L1 | [`l1/`](l1/) | Proxmox infrastructure: cloud images and VMs, managed with OpenTofu | Active |
| L2 | `l2/` | Configuration of the VMs after creation (OS setup, users, hardening) | Planned |
| L3 | `l3/` | Applications that run on top of the configured VMs | Planned |

Work from the bottom up: apply L1 to create VMs, then L2 to configure them, then L3 to deploy
applications.

## Secrets

Secrets are never committed. Each layer keeps them in git-ignored files (for example,
`l1/terraform.tfvars`) and ships a `*.example` copy to start from. The root `.gitignore`
applies to all layers. Before you push, run `git status` and check that no secret files or
state files are listed.
