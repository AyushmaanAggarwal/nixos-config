{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  main-org = "myDune";
  main-bucket = "spiceSilos";
  influxdb-secrets-options = {
    owner = "influxdb2";
    group = "influxdb2";
    mode = "0400";
    sopsFile = ../../../secrets/grafana/grafana.yaml;
  };
in
{
  imports = [
    ./caddy.nix
    ../core/sops-nix.nix
  ];

  options = {
    grafana.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Grafana and Influxdb";
      default = false;
    };
  };

  config = lib.mkIf (config.grafana.enable) {
    sops.secrets = {
      influxdb_admin_password = influxdb-secrets-options;
      influxdb_admin_token = influxdb-secrets-options;
      influxdb_user_password = influxdb-secrets-options;
      influxdb_pve_token = influxdb-secrets-options;
    };

    # --------------------
    # Grafana
    # --------------------
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          enforce_domain = true;
          enable_gzip = true;
          domain = "grafana.tail590ac.ts.net";
          root_url = "https://grafana.tail590ac.ts.net/grafana/";
          serve_from_sub_path = true;
        };

        # Prevents Grafana from phoning home
        analytics.reporting_enabled = false;
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "${main-bucket}";
            type = "influxdb";
            url = "http://127.0.0.1:8006";
            editable = true;
          }
          {
            name = "proxmox";
            type = "influxdb";
            url = "http://127.0.0.1:8006";
          }
        ];
      };
    };

    # --------------------
    # Influx DB
    # --------------------
    services.influxdb2 = {
      enable = true;
      settings = {
        http-bind-address = "127.0.0.1:8006";
      };

      provision = {
        enable = true;

        initialSetup = {
          username = "admin";
          retention = 0;
          passwordFile = config.sops.secrets.influxdb_admin_password.path;
          organization = "${main-org}";
          bucket = "${main-bucket}";
          tokenFile = config.sops.secrets.influxdb_admin_token.path;
        };

        users.ayushmaan = {
          present = true;
          passwordFile = config.sops.secrets.influxdb_user_password.path;
        };

        organizations.${main-org} = {
          present = true;
          description = "General Organization";

          buckets = {
            "proxmox" = {
              present = true;
              description = "Proxmox Bucket";
              retention = 0;
            };
          };

          auths = {
            pve = {
              present = true;
              description = "Allow read/write for proxmox server";
              tokenFile = config.sops.secrets.influxdb_pve_token.path;
              readBuckets = [ "proxmox" ];
              readPermissions = [ "buckets" ];
              writeBuckets = [ "proxmox" ];
              writePermissions = [ "buckets" ];
            };
            admin = {
              present = true;
              description = "Allow read/write for admin";
              allAccess = true;
            };
            ayushmaan = {
              present = true;
              description = "Allow read/write for admin";
              allAccess = true; # Eventually restrict to necessary permissions
            };
          };
        };
      };
    };

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      custom_proxy = ''
        reverse_proxy /grafana/* 127.0.0.1:3000
        reverse_proxy /influxdb/* 127.0.0.1:8006
      '';
    };
  };
}
