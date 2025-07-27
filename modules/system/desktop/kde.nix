{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    kde.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable KDE Desktop Enviroment";
      default = false;
    };
  };

  config = lib.mkIf (config.kde.enable) {
    services.xserver.enable = true; # optional
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;
  };
}
