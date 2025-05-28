{ config, lib, pkgs, ... }:
{
  imports = [ ./sops-nix.nix ];
  
  # -------------------- 
  # Users
  # -------------------- 
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "/run/current-system/sw/bin/nix-env ^-p /nix/var/nix/profiles/system --set /nix/store/[0-9a-z]+-nixos-system-unnamed-(lxc-proxmox-)?[0-9a-g\\.]+$";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemd-run ^-E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait (true|/nix/store/\\S+/bin/switch-to-configuration (switch|boot))$";
          options = [ "NOPASSWD" ];
        }
      ];
      users = [ "nixadmin" ];
    }];
  };
 
  users.users = {
    nixadmin = { 
      isNormalUser = true; description = "Nixpkgs User"; # Used as a minimal remote builder
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$MsKPpS9seZjFQTddCHJ.g0$WeGelFn99zcnxhW.QdoIC.ZslQLxgBm4a7sQKdfBdC7";
      openssh.authorizedKeys = {
        keys = [ 
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKF5IDpNa1gIA9lNUv/j0p5Yicf68YJUYsxIitpwTfPVAAAABHNzaDo=" # Type A
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOuQHAZ1ATX5y5z3gQHR8Bp52ZBoPmLN1/iap8hYjw7eAAAABHNzaDo=" # Type C
        ];
      };
    };

    proxmox = { 
      isNormalUser = true; description = "Proxmox User"; # Primary non-root user in container
      extraGroups = [ "networkmanager" "wheel" ]; 
      packages = with pkgs; [
        neovim
        htop
        powertop
        fastfetch
      ];
      hashedPassword = "$y$j9T$nuV.3iXRhPpKvTXd94fFh.$9g4xyPrktivR.wpwUxT4P69bs0NLLAe2sDWDIjus5c4";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa53AGMV87VUquUKyQ2NlqmZiN7OVV438VLUe6hYJU2" ];
    };
  };

  
  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [ 
    vim
    git
    gcc
    wget
    bash
  ];
}

