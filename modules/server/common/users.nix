{
  config,
  lib,
  pkgs,
  functions,
  hostname,
  username,
  system,
  sshWithoutYubikey,
  ...
}:
let
  ssh_primary = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKF5IDpNa1gIA9lNUv/j0p5Yicf68YJUYsxIitpwTfPVAAAABHNzaDo=" # yubikey_type_a
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOuQHAZ1ATX5y5z3gQHR8Bp52ZBoPmLN1/iap8hYjw7eAAAABHNzaDo=" # yubikey_type_c
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfo5bbYZcxVwve1XSj+pYaxmdlTKBr8L9dNeCCloZ1M" # backup
  ];

  ssh_unsecure = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa53AGMV87VUquUKyQ2NlqmZiN7OVV438VLUe6hYJU2" # thegram
  ];

  ssh_containers = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLX97kPiXxKA8W0TFpkkwvtWKY8QSCMyCNSe1PmEl7N" # uptime
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFgk0VQzuFSzeHfT5Wd4tGQLzRvzCKgeAtvmoU00YAs" # changedetection
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAiDptqCUt/I5DJRSt15RB6p9ZToHgdcT+c3U6aS01r" # immich
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF5tBOnQ7FrDZvlgkKsMIisIEm/eB+Xwc/evqKF5dw3g" # nextcloud
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuwJYFfBZLG6feRKBFfa7+dWzAUBvmqA++JnJUrj+mG" # adguard
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEo956tAmvf+G4fKmKP6Box+te3vDQe22qMYCLrrWlmE" # ntfy
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICQPeb1/e8Hzr3S5/LwGHNbwjupo5UZ3W3UctpUl1Pyv" # mealie
  ];
in
{
  config = lib.mkMerge [
    {
      # --------------------
      # Users
      # --------------------
      security.sudo = {
        enable = true;
        extraRules = [
          {
            commands = [
              {
                command = "/run/current-system/sw/bin/nix-env ^-p /nix/var/nix/profiles/system --set /nix/store/[0-9a-z]+-nixos-system-unnamed-(lxc-proxmox-)?[0-9a-g\\.]+$";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/systemd-run ^-E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait (true|/nix/store/\\S+/bin/switch-to-configuration (switch|boot))$";
                options = [ "NOPASSWD" ];
              }
              {
                command = "/run/current-system/sw/bin/env ^NIXOS_INSTALL_BOOTLOADER=0 systemd-run -E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration (true|/nix/store/\\S+/bin/switch-to-configuration (switch|boot))$";
                options = [ "NOPASSWD" ];
              }

            ];
            users = [ "nixadmin" ];
          }
        ];
      };

      # Enable backup server to act as a remote builder
      programs.ssh.knownHosts.backup.publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKfo5bbYZcxVwve1XSj+pYaxmdlTKBr8L9dNeCCloZ1M"; # backup

      users.users = {
        nixadmin = {
          isNormalUser = true;
          description = "Nixpkgs User"; # Used as a minimal remote builder
          extraGroups = [ "wheel" ];
          hashedPassword = "$y$j9T$MsKPpS9seZjFQTddCHJ.g0$WeGelFn99zcnxhW.QdoIC.ZslQLxgBm4a7sQKdfBdC7";
          openssh.authorizedKeys.keys = ssh_primary;
        };

        proxmox = {
          isNormalUser = true;
          description = "Proxmox User"; # Primary non-root user in container
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
          packages = with pkgs; [
            neovim
            htop
            powertop
            fastfetch
          ];
          hashedPassword = "$y$j9T$nuV.3iXRhPpKvTXd94fFh.$9g4xyPrktivR.wpwUxT4P69bs0NLLAe2sDWDIjus5c4";
          openssh.authorizedKeys.keys = ssh_primary ++ ssh_unsecure;
        };
      };
    }
    (lib.mkIf ("${hostname}" == "backup") {
      users.users.proxmox.openssh.authorizedKeys.keys = ssh_containers;
    })
  ];
}
