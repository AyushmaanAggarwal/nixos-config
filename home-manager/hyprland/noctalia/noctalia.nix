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
  imports = [
    inputs.noctalia.homeModules.default
  ];
  options = {
    noctalia.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable noctalia";
      default = false;
    };
  };
  config = lib.mkIf (config.noctalia.enable) {
    programs.noctalia-shell = {
      enable = true;
      settings = ./settings.json;
    };
  };
}
