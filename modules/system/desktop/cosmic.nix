{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    cosmic.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Cosmic Desktop Enviroment";
      default = false;
    };
  };

  config = lib.mkIf (config.cosmic.enable) {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
