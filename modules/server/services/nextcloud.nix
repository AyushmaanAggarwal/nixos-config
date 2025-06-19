# Applications
{
  config,
  lib,
  pkgs,
  ...
}: 
let
  secrets-file = ../../../secrets/nextcloud/secrets.yaml;
in
{
  imports = [
    ../common/sops-nix.nix
    ./caddy.nix
    ./tailscale.nix
  ];
  options = {
    nextcloud.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Nextcloud";
      default = false;
    };
  };

  config = lib.mkIf (config.nextcloud.enable) {
    sops.secrets.nextcloud_database = {
      owner = "nextcloud";
      group = "nextcloud";
      mode = "0400";
      sopsFile = secrets-file;
    };
    # --------------------
    # Syncthing
    # --------------------
    services.syncthing = {
      enable = true;
      openDefaultPorts = false;
    };

    # --------------------
    # Nextcloud Configuration
    # --------------------
    services.nextcloud = {
      enable = true;
      hostName = "localhost";
      settings = {
        trusted_domains = ["nextcloud.tail590ac.ts.net"];
        trusted_proxies = ["127.0.0.1"];
      };
      extraApps = {
        inherit
          (config.services.nextcloud.package.packages.apps)
          news
          contacts
          calendar
          tasks
          ;
      };
      extraAppsEnable = true;
      autoUpdateApps.enable = true;

      database.createLocally = true;
      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = config.sops.secrets.nextcloud_database.path;
      };
    };
    services.nginx.virtualHosts."localhost".listen = [
      {
        addr = "127.0.0.1";
        port = 8080;
      }
    ];

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      custom_proxy = ''
        redir /.well-known/carddav /remote.php/dav 301
        redir /.well-known/caldav /remote.php/dav 301
        redir /.well-known/webfinger /index.php/.well-known/webfinger 301
        redir /.well-known/nodeinfo /index.php/.well-known/nodeinfo 301
        reverse_proxy 127.0.0.1:8080
      '';
    };
  };
}
