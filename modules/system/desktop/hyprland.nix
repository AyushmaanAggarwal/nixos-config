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
    services.hypridle.enable = true;
    programs.hyprlock.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    # GDM
    services.displayManager.cosmic-greeter.enable = true;
    programs.uwsm.waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
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
      
      kdePackages.polkit-kde-agent-1

    ];

    # --------------------
    # Polkit Authentication Agent Service
    # --------------------
    systemd.user.services = {
      # Authentication Agent
      polkit-kde-authentication-agent = {
        description = "polkit-kde-authentication-agent";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
