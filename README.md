Welcome to my combined nixos configuration for desktop and proxmox lxc containers for various services. This is still an evolving nix-config, so expect breaking changes.

The current services running in production are
- Uptime
- Immich
- Adguard
- Nextcloud

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
