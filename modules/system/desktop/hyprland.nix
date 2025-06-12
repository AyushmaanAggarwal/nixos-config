{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [../systemd/polkit.nix];

  options = {
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Hyprland Window Manager";
      default = false;
    };
  };

  config = lib.mkIf (config.hyprland.enable) {
    polkit-auth.enable = true;
    fuzzel.enable = true; # Enables fuzzel in hm

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
  };
}
