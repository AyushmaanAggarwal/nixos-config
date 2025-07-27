{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./caddy.nix
    ./tailscale.nix
  ];
  options = {
    uptime.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Uptime Kuma";
      default = false;
    };
  };

  config = lib.mkIf (config.uptime.enable) {
    # Uptime Kuma
    services.uptime-kuma.enable = true;

    # Caddy SSL Cert
    caddy = {
      enable = true;
      port = 3001;
    };
    # Need non-userspace networking for device pings
    tailscale.userspace.enable = false;
  };
}
