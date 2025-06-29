> [!IMPORTANT]  
> This repo is rapidly evolving, so expect breaking changes from time to time

# NixOS Configuration
Welcome to my combined nixos configuration for desktop and proxmox lxc containers for various services. 

# Machines
I currently manage two machines
- thegram: a personal laptop
- proxmox: a proxmox host that hosts several NixOS LXC containers

## Self-Hosted Services
The current services running in production are
- Uptime
- Immich
- Adguard
- Nextcloud
- Mealie - Recipe Manager
- ntfy.sh - Notification Server
- changedetection.io - Website Change Detection

Planned Additions
- NewsBlur - RSS feed reader
- GitLab - Git Hosting Platform (for backups)
- A ![Old Website](https://github.com/AyushmaanAggarwal/theCounter/tree/main)
- Graphana + InfluxDB

### Guide for using LXC containers
Begin by building a lxc container for proxmox by running the following command:
```nix
nix run github:nix-community/nixos-generators -- --flake .#<service name> --cores 4 -f proxmox-lxc
```

Then, start up the proxmox lxc container with default settings except with the desired hostname and dhcp ip address.

After starting the lxc container, log into tailscale with the following command:
```sh
sudo tailscale login
```

In order to update a server remotely, run the following command:
```nix
make <hostname>
```
