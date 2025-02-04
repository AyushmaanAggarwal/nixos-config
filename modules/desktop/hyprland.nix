# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{
  imports = [
    ../system/systemd/polkit.nix
  ];

  programs.hyprland = {
    enable = true;
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
