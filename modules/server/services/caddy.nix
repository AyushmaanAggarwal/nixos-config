{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./tailscale.nix
  ];
  options = {
    caddy.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Caddy";
      default = false;
    };
    caddy.url = lib.mkOption {
      type = lib.types.str;
      description = "Set Caddy Url for simple reverse proxy";
      default = "127.0.0.1";
    };
    caddy.port = lib.mkOption {
      type = lib.types.port;
      description = "Set Caddy Port for simple reverse proxy";
      default = 8080;
    };
    caddy.custom_proxy = lib.mkOption {
      type = lib.types.str;
      description = "Set custom Caddy reverse proxy";
      default = "";
    };
    caddy.hostname = lib.mkOption {
      type = lib.types.str;
      description = "Set hostname for tailscale caddy-configuration";
      default = config.networking.hostName;
    };
  };

  config = lib.mkIf (config.caddy.enable) {
    # --------------------
    # Caddy SSL Cert
    # --------------------
    services.caddy = {
      enable = true;
      virtualHosts."${config.caddy.hostname}.tail590ac.ts.net".extraConfig =
        if (config.caddy.custom_proxy == "")
        then ''reverse_proxy ${config.caddy.url}:${toString config.caddy.port}''
        else config.caddy.custom_proxy;
    };
    tailscale.caddycert.enable = true;
  };
}
