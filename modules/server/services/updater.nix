{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}:
{
  options = {
    updater.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable updater";
      default = (hostname == "backup");
    };
  };
  config = lib.mkIf (config.updater.enable) {
    systemd.services.nixpkgs-updater = {
      enable = true;
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      description = "Update all nixos containers";
      script = ''
        #!/bin/sh

        online_devices=''$(tailscale status --json | jq -r '.Peer[] | select(.Tags[]? == "tag:container") | select(.Online == true) | .HostName')

        for device in ''$online_devices; do
          echo "starting upgrade for ''${device} -----------------------"
          nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system#''${device} --target-host nixadmin@''${device} || true
        done
      '';
      serviceConfig = {
        User = "proxmox";
      };
    };

    systemd.timers.nixpkgs-updater = {
      enable = true;
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        Unit = "nixpkgs-updater.service";
      };
    };
  };
}
