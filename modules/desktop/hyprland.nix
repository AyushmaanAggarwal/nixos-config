# Hyprland Window Manager and Configuration
{ config, pkgs, ... }:
{
  imports = [
    ../system/systemd/polkit.nix
  ];
  
  services.hypridle.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;
  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
  };

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
