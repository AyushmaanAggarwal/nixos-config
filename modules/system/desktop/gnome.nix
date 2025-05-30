{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    gnome.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Gnome Desktop Enviroment";
      default = false;
    };
  };

  config = lib.mkIf (config.gnome.enable) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
