{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  domain-name,
  ...
}:
let
  secrets-file = ../../../secrets/nextcloud/secrets.yaml;
  port = 28981;
in
{
  imports = [
    ../common/sops-nix.nix
  ];
  options = {
    paperless.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable paperless";
      default = false;
    };
  };
  config = lib.mkIf (config.paperless.enable) {
    sops.secrets.paperless-pass = {
      owner = config.paperless.user;
      group = config.paperless.group;
      mode = "0400";
      sopsFile = secrets-file;
    };

    services.paperless = {
      enable = true;
      dataDir = "/var/lib/paperless";
      passwordFile = config.sops.secrets.paperless-pass.path;

      # For reverse proxying
      domain = domain-name;

      # For serving locally before reverse proxy
      address = "127.0.0.1";
      port = port;
    };
  };
}
