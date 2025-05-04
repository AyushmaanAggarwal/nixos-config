{ config, pkgs, ... }:
{
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10; # <15% free
    freeMemKillThreshold = 10; # <15% free
    freeSwapThreshold = 90;
    freeSwapKillThreshold = 80;
    extraArgs = [ 
      "--prefer"
      "(^|/)(thunderbird|firefox|slack|vscode)$"
      "--avoid"
      "(^|/)(Hyprland|hypridle|hyprlock|hyprpaper|kitty|waybar|systemd|networkmanager|nsncd|dbus)$"
    ];
  };
}
