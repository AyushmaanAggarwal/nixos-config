{ pkgs, lib, ... }:
{
  # Backlight (as systemd times out too often)
  systemd.services."systemd-backlight@leds:kbd_backlight".enable = lib.mkForce false;

  systemd.services.restore-backlight = {
    enable = true;
    wants = [
      "sys-devices-pci0000:00-0000:00:02.0-drm-card1-card1\\x2deDP\\x2d1-intel_backlight.device"
    ];
    before = [ "sysinit.target" ];
    after = [
      "systemd-journald.socket"
      "-.mount"
      "systemd-remount-fs.service"
      "system-systemd\\x2dbacklight.slice"
    ];
    description = "Restore Backlight";
    serviceConfig = {
      User = "ayushmaan";
      Type = "oneshot";
      Restart = "no";
      TimeoutStartSec = "30s";
      ExecStart = "env XDG_RUNTIME_DIR=$HOME/.cache brightnessctl -r";
    };
  };

  systemd.services.save-backlight = {
    enable = true;
    before = [ "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    description = "Save Backlight";
    serviceConfig = {
      User = "ayushmaan";
      Type = "oneshot";
      Restart = "no";
      TimeoutStartSec = "30s";
      ExecStart = "env XDG_RUNTIME_DIR=$HOME/.cache brightnessctl -s";
    };
  };

}
