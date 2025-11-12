> [!IMPORTANT]  
> This repo is rapidly evolving, so expect breaking changes from time to time

# NixOS Configuration
Welcome to my combined nixos configuration for my personal desktop and proxmox lxc containers for various services. 

# Machines
I currently manage two machines
- thegram: a personal laptop
- proxmox: a proxmox host that hosts several NixOS LXC containers

## Personal Machine
### System Setup
- Disko managed ZFS Filesystem with automatic snapshots and replication
- NTS encrypted time settings
- Encrypted DNS
- Home-manager
- Hyprland Desktop

### Post-install Checklist
- [ ] setup new password for user and root
- [ ] ssh key 
- [ ] setup rclone + restic
- [ ] sops-nix backup config/switch out ssh key
- [ ] setup tailscale
- [ ] maybe more
## Proxmox Machine
### Self-Hosted Services
The current services running in production are
- Uptime
- Immich
- Adguard
- Nextcloud
- Jellyfin - Media Playback
- Glance - homepage
- Mealie - Recipe Manager
- Ntfy.sh - Notification Server
- Changedetection.io - Website Change Detection
- Paperless-ngx - document archiver and manager

Planned Additions
- NewsBlur - RSS feed reader
- GitLab - Git Hosting Platform (for backups)
- A ![Old Website](https://github.com/AyushmaanAggarwal/theCounter/tree/main)
- Graphana + InfluxDB

### Guide for using LXC containers
Begin by building a lxc container for proxmox by running the following command:
```sh
nix run github:nix-community/nixos-generators -- --flake .#<service name> --cores 4 -f proxmox-lxc
```

Then, start up the proxmox lxc container with default settings except with the desired hostname and dhcp ip address.

After starting the lxc container, log into tailscale with the following command:
```sh
sudo tailscale login
```

In order to update a server remotely, run the following command:
```sh
make <hostname>
```
or for all machines
```sh
make all-server -i 
```
