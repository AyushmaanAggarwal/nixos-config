{ config, pkgs, ... }:
{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.xserver.enable = true; # optional
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
}
