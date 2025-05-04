{ inputs, config, lib, pkgs, ... }:
{
  imports = [ 
    ./hyprland.nix
    ./kde.nix
    ./gnome.nix
    ./cosmic.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
