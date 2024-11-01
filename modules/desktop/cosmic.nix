{ config, pkgs, ... }:
{
  modules = [
    nixos-cosmic.nixosModules.default
  ];

  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}

