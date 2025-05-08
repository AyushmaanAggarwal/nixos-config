{ inputs, outputs, config, lib, pkgs, home-manager, ... }:
{
  imports = [
    ../../modules/system/default.nix
    ../../modules/scripts/default.nix
    ../../home-manager/home.nix
    ./hardware-configuration.nix
  ];
 
  # Desktop Enviroment
  hyprland.enable = true;

  # Developer Enviroment
  developer-enviroment = {
    enable = true;
    user = "ayushmaan";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { 
    LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8"; 
    LC_MEASUREMENT = "en_US.UTF-8"; 
    LC_MONETARY = "en_US.UTF-8"; 
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8"; 
    LC_PAPER = "en_US.UTF-8"; 
    LC_TELEPHONE = "en_US.UTF-8"; 
    LC_TIME = "en_US.UTF-8";
  };

  # Do not edit the following line
  system.stateVersion = "24.05"; 
}
