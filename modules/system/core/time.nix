{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # NTP Servers
  services.ntpd-rs = {
    enable = true;
    useNetworkingTimeServers = false;
    settings = {
      source-defaults = {
        # in units of log2 time
        poll-interval-limits = {
          min = 1;
          max = 5;
        };
        initial-poll-interval = 3;
      };
      source =
        lib.map
          (s: {
            mode = "nts";
            address = s;
          })
          [
            "time.cloudflare.com"
            "paris.time.system76.com"
            "ohio.time.system76.com"
            "oregon.time.system76.com"
            "virginia.time.system76.com"
            "brazil.time.system76.com"
          ];
    };
  };

  # hw clock is broken so set the time to last build time
  environment.etc = {
    "scripts/hwclock.sh" = {
      text = ''
        #!/bin/sh
        hwclock --set --date="$(date -d @$(stat -c %Y /nix/var/nix/profiles/system) '+%Y-%m-%d %H:%M:%S')"
        hwclock -s 
      '';
      mode = "0555";
    };
  };
  systemd.services = {
    reset-hwclock = {
      description = "reset time to build time of last nixos generation";
      before = [ "ntpd-rs.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "/etc/scripts/hwclock.sh";
      };
    };
  };
}
