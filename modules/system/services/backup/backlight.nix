{ pkgs, lib, ... }:
{
  # Backlight (as systemd times out too often)
  systemd.services."systemd-backlight@leds:kbd_backlight".enable = lib.mkForce false;

  systemd.services.reset-backlight = {
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
    description = "Simple Reset Backlight";
    serviceConfig = {
      Type = "oneshot";
      Restart = false;
      TimeoutStartSec = "30s";
      ExecStart = "echo 33000 > /sys/class/backlight/intel_backlight/brightness";
    };
  };
}
