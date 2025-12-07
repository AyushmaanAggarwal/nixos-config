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
let
  # Check if the lxc container has an option under its name
  hostname-nooption = builtins.elem "${hostname}" [ "backup" ];
  hostname-option = !hostname-nooption;
in
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../../modules/server
    ../../modules/shared
  ];
  config = lib.mkMerge [
    (lib.optionalAttrs hostname-option { ${hostname}.enable = true; })
    {
      networking.hostName = hostname;
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
