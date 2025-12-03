{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    earlyoom.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Start Earlyoom Service";
      default = true;
    };
  };
  config = lib.mkIf (config.earlyoom.enable) {
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 30; # <15% free
      freeMemKillThreshold = 10; # <15% free
      freeSwapThreshold = 90;
      freeSwapKillThreshold = 80;
      extraArgs = [
        "--prefer"
        "(thunderbird|slack|vscode|spotify|iscord|electron)"
        "--avoid"
        "(Hyprland|hypr|systemd|networkmanager|nsncd|dbus|xdg|dnscrypt)"
      ];
    };
    services.systembus-notify.enable = true;
  };
}
