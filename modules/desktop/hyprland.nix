# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;
  users.users.ayushmaan.packages = with pkgs; [
      hyprlock
      hyprpaper
      waybar
      dunst
      pavucontrol
      
      # Terminal
      ## Screenshots
      grim
      slurp
      wl-clipboard

  ];
}
