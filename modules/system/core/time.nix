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
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [
      "time.cloudflare.com"
      "paris.time.system76.com"
      "ohio.time.system76.com"
      "oregon.time.system76.com"
      "virginia.time.system76.com"
      "brazil.time.system76.com"
    ];
    extraConfig = ''
      makestep 0.1 10
    '';
    extraFlags = [ "-s" ];
  };
}
