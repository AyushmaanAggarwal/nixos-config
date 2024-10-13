# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{
  programs.hyprland.enable = true;
  users.users.ayushmaan.packages = with pkgs; [
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
