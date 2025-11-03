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
}
