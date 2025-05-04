{ config, lib, pkgs, ... }:
{
  options = {
    tailscale.userspace.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Tailscale Userspace Networking for Containers";
      default = true;
    };
    tailscale.caddycert.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Caddy user to create Certs";
      default = false;
    };
    tailscale.dns.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables DNS Flags for Tailscale";
      default = false;
    };
  };

  config = {
    services.tailscale = {
      enable = true;
      disableTaildrop = true;
      extraDaemonFlags = [ "--no-logs-no-support" ];
      interfaceName = lib.mkIf (config.tailscale.userspace.enable) "userspace-networking";

      permitCertUid = lib.mkIf (config.tailscale.caddycert.enable) "caddy";

      useRoutingFeatures = lib.mkIf (config.tailscale.dns.enable) "server";
      extraSetFlags = lib.mkIf (config.tailscale.dns.enable) [
        "--accept-dns=false" # Ensure tailscale doesn't interfere with adguard dns
      ];
    };
  };
}

