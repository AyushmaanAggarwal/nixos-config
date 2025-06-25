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
}: let
  ssh_unsecure = ["thegram"];
  ssh_primary = [
    "yubikey_type_a" 
    "yubikey_type_c" 
    "backup"
  ];
  ssh_containers = lib.mkIf ("${hostname}" == "backup") [
    "uptime"
    "changedetection"
    "immich"
    "nextcloud"
    "adguard"
    "ntfy"
    "mealie"
  ];
in {
  imports = [./sops-nix.nix];

  sops.secrets = functions.listToAttrsAttrs (ssh_unsecure ++ ssh_primary ++ ssh_containers) {
    user = "root";
    group = "root";
    mode = "0400";
    sopsFile = ../../../secrets/general/ssh_keys.yaml;
  };

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
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/systemd-run ^-E LOCALE_ARCHIVE -E NIXOS_INSTALL_BOOTLOADER= --collect --no-ask-password --pipe --quiet --service-type=exec --unit=nixos-rebuild-switch-to-configuration --wait (true|/nix/store/\\S+/bin/switch-to-configuration (switch|boot))$";
            options = ["NOPASSWD"];
          }
        ];
        users = ["nixadmin"];
      }
    ];
  };

  # Enable backup server to act as a remote builder
  programs.ssh.knownHosts.backup.publicKey = config.sops.secrets.backup.path;

  users.users = {
    nixadmin = {
      isNormalUser = true;
      description = "Nixpkgs User"; # Used as a minimal remote builder
      extraGroups = ["wheel"];
      hashedPassword = "$y$j9T$MsKPpS9seZjFQTddCHJ.g0$WeGelFn99zcnxhW.QdoIC.ZslQLxgBm4a7sQKdfBdC7";
      openssh.authorizedKeys.keyFiles = lib.map (file: config.sops.secrets."${file}".path) ssh_primary;
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
      openssh.authorizedKeys.keys = lib.map (file: config.sops.secrets."${file}".path) ssh_primary ++ ssh_unsecure ++ ssh_containers;
    };
  };
}
