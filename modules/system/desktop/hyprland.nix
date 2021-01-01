{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
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
    services.displayManager.gdm.enable = true;
    programs.uwsm.waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };

    users.users.${username}.packages = with pkgs; [
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
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    # --------------------
    # Disable trackpad
    # --------------------
    environment.etc = {
      "scripts/disable_trackpad.sh" = {
        text = ''
          #!/bin/sh

          # Set device to be toggled
          HYPRLAND_DEVICE="pxic2642:00-04ca:00b1-touchpad"
          HYPRLAND_VARIABLE="device[$HYPRLAND_DEVICE]:enabled"

          if [ -z "$XDG_RUNTIME_DIR" ]; then
            export XDG_RUNTIME_DIR=/run/user/$(id -u)
          fi

          # Check if device is currently enabled (1 = enabled, 0 = disabled)
          DEVICE="$(hyprctl getoption $HYPRLAND_VARIABLE | grep 'int: 1')"

          if [ -z "$DEVICE" ]; then
          	# if the device is disabled, then enable
            	notify-send -u normal "Enabling Touchpad"
          	hyprctl keyword $HYPRLAND_VARIABLE true
          else
          	# if the device is enabled, then disable
          	notify-send -u normal "Disabling Touchpad"
          	hyprctl keyword $HYPRLAND_VARIABLE false
          fi
        '';
        mode = "0555";
      };
    };

  };
}
