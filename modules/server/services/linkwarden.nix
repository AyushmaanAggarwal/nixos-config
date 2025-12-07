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

    services.linkwarden = {
      enable = true;
      port = port;
      host = "localhost";
      user = linkwarden-user;
      group = linkwarden-user;
      openFirewall = false;
      secretFiles = {
        NEXTAUTH_SECRET = config.sops.secrets.nextauth-secret.path;
      };
      enableRegistration = true;
      database = {
        name = "linkwarden";
        createLocally = true;
      };
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
