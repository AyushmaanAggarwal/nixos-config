{ inputs, config, pkgs, modulesPath, ... }:
{ 
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/server/common/sops-nix.nix
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
