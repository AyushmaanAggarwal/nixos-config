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
    settings = {
      source = (
        lib.forEach
          [
            "time.cloudflare.com"
            "paris.time.system76.com"
            "ohio.time.system76.com"
            "oregon.time.system76.com"
            "virginia.time.system76.com"
            "brazil.time.system76.com"
          ]
          (address: {
            mode = "nts";
            address = "${address}";
          })
      );
      synchronization = {
        minimum-agreeing-sources = 3;
      };
    };
  };
}
