{
  config,
  lib,
  pkgs,
  ...
}:
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
    tailscale.exit-node.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Exit Node Flags for Tailscale";
      default = false;
    };
  };

  config = lib.mkMerge [
    lib.mkIf
    config.tailscale.userspace.enable
    {
      services.tailscale.extraDaemonFlags = [ "--tun=userspace-networking" ];
    }
    {
      services.tailscale = {
        enable = true;
        package = pkgs.unstable.tailscale;
        disableTaildrop = true;
        extraDaemonFlags = [
          "--no-logs-no-support"
          "--tun=userspace-networking"
        ];

        interfaceName = lib.mkIf (config.tailscale.userspace.enable) "userspace-networking";

        permitCertUid = lib.mkIf (config.tailscale.caddycert.enable) "caddy";

        useRoutingFeatures = lib.mkIf (config.tailscale.dns.enable) "server";
        extraSetFlags = lib.mkMerge [
          (lib.mkIf config.tailscale.dns.enable [ "--accept-dns=false" ]) # Ensure tailscale doesn't interfere with adguard dns
          (lib.mkIf config.tailscale.exit-node.enable [ "--advertise-exit-node" ])
        ];
      };
    }
  ];
}
