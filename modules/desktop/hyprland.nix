# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{
  imports = [
    ../system/systemd/polkit.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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
