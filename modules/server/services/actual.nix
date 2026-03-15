{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}:
let
  port = 5909;
in
{
  imports = [
    ./caddy.nix
  ];
  options = {
    actual.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable actual";
      default = false;
    };
  };

  config = lib.mkIf (config.actual.enable) {
    services.actual = {
      enable = true;
      openFirewall = false;

      settings = {
        port = 5909;
        hostname = "localhost";
        dataDir = "/var/lib/actual";
      };
    };

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 8283;
    };
  };
}
