{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    hypridle.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable hypridle";
      default = false;
    };
  };
  config = lib.mkIf (config.hypridle.enable) {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        listener = [
          {
            timeout = 1800; # 2.5min.
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
            on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
          }

          {
            timeout = 3800; # 1.05 hours
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = 5500; # 1.5 hours
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
          }

          {
            timeout = 10800; # 3 hrs
            on-timeout = "systemctl suspend"; # suspend pc
          }
        ];
      };
    };
  };
}
