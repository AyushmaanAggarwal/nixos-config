{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
}

