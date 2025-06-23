{
  inputs,
  options,
  config,
  lib,
  pkgs,
  modulesPath,
  hostname,
  username,
  desktop,
  system,
  isTailscaleExitNode,
  sshWithoutYubikey,
  ...
}: let
  hostname-option = builtins.elem "${hostname}" [
    "adguard"
    "changedetection"
    "etebase"
    "grafana"
    "immich"
    "mealie"
    "nextcloud"
    "ntfy"
    "uptime"
  ];
in {
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/server
    ../../modules/shared
  ];
  config = lib.mkMerge [
    (lib.optionalAttrs hostname-option {${hostname}.enable = true;})
    (lib.optionalAttrs sshWithoutYubikey {
      users.users.${username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa53AGMV87VUquUKyQ2NlqmZiN7OVV438VLUe6hYJU2"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOmhA7UsDVaSC7A+CLcKnKkYuSjgObaauAFJWdjHmK1X ayushmaan@thegram"
      ];
    })
    {
      networking.hostName = hostname;
      caddy.hostname = hostname;
      tailscale.exit-node.enable = isTailscaleExitNode;

      # Disable bad systemd units for lxc containers
      systemd.suppressedSystemUnits = [
        "dev-mqueue.mount"
        "sys-kernel-debug.mount"
        "sys-fs-fuse-connections.mount"
      ];

      time.timeZone = "America/New_York";
      system.stateVersion = "25.05";
    }
  ];
}
