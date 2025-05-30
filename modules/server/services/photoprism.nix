# Warning: Not in production anymore
{ config, lib, pkgs, ... }:
{
  options = {
    photoprism.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Photoprism";
      default = false;
    };
  };

  config = lib.mkIf (config.photoprism.enable) {  
    # -------------------- 
    # Various services
    # -------------------- 
    services.photoprism = {
      enable = true;
      port = 2342;
      originalsPath = "/var/lib/private/photoprism/originals";
      address = "0.0.0.0";
      passwordFile = "/home/proxmox/.secrets/photoprism";
      settings = {
        PHOTOPRISM_ADMIN_USER = "photoprismAdmin";
        PHOTOPRISM_DEFAULT_LOCALE = "en";
        PHOTOPRISM_DATABASE_DRIVER = "mysql";
        PHOTOPRISM_DATABASE_NAME = "photoprism";
        PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
        PHOTOPRISM_DATABASE_USER = "photoprismUser";
        PHOTOPRISM_SITE_URL = "http://photoprism.tail590ac.ts.net:2342";
        PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      dataDir = "/data/mysql";
      ensureDatabases = [ "photoprism" ];
      ensureUsers = [ {
        name = "photoprism";
        ensurePermissions = {
          "photoprism.*" = "ALL PRIVILEGES";
        };
      } ];
    };

    # NGINX
    services.nginx = {
      enable = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      clientMaxBodySize = "1000m";
      virtualHosts = {
        "photoprism.tail590ac.ts.net" = {
          forceSSL = true;
          enableACME = true;
          http2 = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:2342";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
              proxy_buffering off;
              proxy_http_version 1.1;
            '';
          };
        };
      };
    };
  };
}

