{ inputs, config, lib, pkgs, ... }:
{
  options = {
    mealie.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Mealie Recipe Manager";
      default = false;
    };
  };
  config = lib.mkIf (config.mealie.enable) {
    services.mealie = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9000;
      database.createLocally = true;
      credentialsFile = "/run/secrets/mealie-credentials.env";
      settings = {

      };
    };

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 9000;
    };
  };
}
