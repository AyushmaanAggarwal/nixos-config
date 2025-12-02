{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  secrets-file = ../../../secrets/onlyoffice/secrets.yaml;
in
{
  options = {
    onlyoffice.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable OnlyOffice";
      default = false;
    };
  };
  config = lib.mkIf (config.onlyoffice.enable) {
    sops.secrets.jwt = {
      owner = "onlyoffice";
      group = "onlyoffice";
      mode = "0400";
      sopsFile = secrets-file;
    };

    # --------------------
    # Only Office
    # --------------------
    services.onlyoffice = {
      enable = true;
      hostname = "localhost";
      port = 8123;
      jwtSecretFile = config.sops.secrets.jwt.path;
    };
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "corefonts"
      ];

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 11434;
    };
  };
}
