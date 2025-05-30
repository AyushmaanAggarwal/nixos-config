{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    polkit-auth.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Polkit Authentication Agent for Hyprland";
      default = false;
    };
  };
  config = lib.mkIf (config.polkit-auth.enable) {
    # --------------------
    # Polkit Authentication Agent Service
    # --------------------
    systemd.user.services = {
      # Authentication Agent
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
