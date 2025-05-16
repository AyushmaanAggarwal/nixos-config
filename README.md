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
- changedetection.io - Website Change Detection

Planned Additions
- NewsBlur - RSS feed reader
- GitLab - Git Hosting Platform (for backups)
- A ![Recipe Manager](https://github.com/awesome-selfhosted/awesome-selfhosted?tab=readme-ov-file#recipe-management)
- A ![Old Website](https://github.com/AyushmaanAggarwal/theCounter/tree/main)
- Graphana + InfluxDB

### Guide for using LXC containers
Begin by building a lxc container for proxmox by running the following command:
```nix
nix run github:nix-community/nixos-generators -- --flake <path to folder>/server-system#<service name> --cores 4 -f proxmox-lxc
```

Then, start up the proxmox lxc container with default settings except with the desired hostname and dhcp ip address.

After starting the lxc container, log into tailscale with the following command:
```sh
sudo tailscale login
```

In order to update a server remotely, run the following command:
```nix
nixos-rebuild switch --flake <path to folder>/server-system#nixos-<service name> --target-host nixadmin@<host-name> --use-remote-sudo
```
