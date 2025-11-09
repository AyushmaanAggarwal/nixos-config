{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    hyprpaper.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Hyprland Wallpaper";
      default = false;
    };
  };
  config = lib.mkIf (config.hyprpaper.enable) {
    programs.hyperpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [
          "/home/ayushmaan/Pictures/Wallpapers/current.jpg"
        ];

        wallpaper = [
          ",/home/ayushmaan/Pictures/Wallpapers/current.jpg"
        ];
      };
    };
  };
}
