# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{

  programs.hyprland = {
    enable = true;
    # set the flake package
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  users.users.ayushmaan.packages = with pkgs; [
      hyprland-qtutils
      hyprlock
      hyprpaper
      dunst
      waybar
      fuzzel
      
      # Terminal
      ## Screenshots
      grim
      slurp
      wl-clipboard

      # System Applications
      nautilus
      pavucontrol
  ];
}
