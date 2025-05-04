# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{
  imports = [
    ../system/systemd/polkit.nix
  ];
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.hypridle.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  users.users.ayushmaan.packages = with pkgs; [
      hyprland-qtutils
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
