{ inputs, config, lib, pkgs, ... }:
{
  options = {
    waybar.enable = lib.mkOption {
      type = lib.types.bool;
      description = "";
      default = false;
    };
    waybar.systemd-target = lib.mkOption {
      type = lib.types.str;
      description = "Systemd target to start waybar";
      default = "wayland-session@Hyprland.target";
    };
  };
  config = lib.mkIf (config.waybar.enable) {
    programs.waybar = {
      enable = true;
      style = ./style.css;
      systemd = {
        enable = true;
        target = config.waybar.systemd-target;
      };
      settings = {
        position = "top";
        layer = "top";
        margin-top = 1;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;    
    
        height = 16;
        spacing = 10;
    
        include = ["~/.config/waybar/modules.json"];
    
        modules-left = [
          "hyprland/workspaces"
        ];
    
        modules-center = [
          "hyprland/window"
        ];
    
        modules-right = [
          "tray"
          #"custom/browser"
          #"custom/xournalpp"
          #"custom/pdfviewer"
          "systemd-failed-units"
          "pulseaudio"
          "backlight" 
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock" 
        ];
    
      };
    };

    xdg.configFile."waybar/modules.json".source = ./modules.json;
  };
}
