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
}: 
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/server/default.nix
  ];
  config = lib.mkMerge [
    lib.mkIf (builtins.hasAttr "${hostname}.enable" options) {
      options.${hostname}.enable = true;
    }
    {
      networking.hostName = hostname;
      caddy.hostname = hostname;
      tailscale.exit-node.enable = isTailscaleExitNode;
      users.users.${username}.openssh.authorizedKeys.keys = lib.mkIf sshWithoutYubikey [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa53AGMV87VUquUKyQ2NlqmZiN7OVV438VLUe6hYJU2"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOmhA7UsDVaSC7A+CLcKnKkYuSjgObaauAFJWdjHmK1X ayushmaan@thegram"
      ];
    
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
