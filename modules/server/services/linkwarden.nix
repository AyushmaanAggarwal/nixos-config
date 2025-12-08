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
  port = 3000;
  linkwarden-user = "linkwarden";
  secrets-file = ../../../secrets/linkwarden/secrets.yaml;
in
{
  imports = [
    ../core/sops-nix.nix
  ];
  options = {
    linkwarden.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable linkwarden";
      default = false;
    };
  };
  config = lib.mkIf (config.linkwarden.enable) {
    sops.secrets.nextauth-secret = {
      owner = linkwarden-user;
      group = linkwarden-user;
      mode = "0400";
      sopsFile = secrets-file;
    };

    sops.secrets.meili-master = {
      owner = linkwarden-user;
      group = linkwarden-user;
      mode = "0400";
      sopsFile = secrets-file;
    };
    services.linkwarden = {
      enable = true;
      host = "127.0.0.1";
      port = port;
      user = linkwarden-user;
      group = linkwarden-user;
      openFirewall = true;
      enableRegistration = true;
      secretFiles = {
        NEXTAUTH_SECRET = config.sops.secrets.nextauth-secret.path;
        MEILI_MASTER_KEY = config.sops.secrets.meili-master.path;
      };
      database = {
        name = "linkwarden";
        createLocally = true;
      };
      environment = {
        MEILI_HOST = "http://localhost:7700";
      };
    };

    services.meilisearch = {
      enable = true;
      listenPort = 7700;
      listenAddress = "127.0.0.1";
      masterKeyFile = config.sops.secrets.meili-master.path;
    };
    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = port;
    };

  };
}
