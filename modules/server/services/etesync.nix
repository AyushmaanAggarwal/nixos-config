{ config, lib, pkgs, ... }:
{
  imports = [
    ./caddy.nix
  ];
  options = {
    etebase.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Etebase";
      default = false;
    };
  };

  config = lib.mkIf (config.etebase.enable) {
    # -------------------- 
    # Etebase Server Setup
    # -------------------- 
    services.etebase-server = {
      enable = true;
      port = 8001;
      dataDir = "/var/lib/etesync-server";
      settings = {
        allowed_hosts = {
          allowed_host1 = "127.0.0.1";
          allowed_host2 = "etebase.tail590ac.ts.net";
        };
        global.secret_file = "/var/lib/etebase-server/secret_file";
      };
    };


    # -------------------- 
    # Caddy SSL Cert
    # -------------------- 
    caddy = {
      enable = true;
      port = 8001;
    };
  };
}
