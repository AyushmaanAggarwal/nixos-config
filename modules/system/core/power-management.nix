{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.thermald.enable = true;
  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.tuned.enable = true;
  services.upower.enable = true;
}
