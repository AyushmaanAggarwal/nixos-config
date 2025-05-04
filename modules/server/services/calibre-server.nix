{ config, lib, pkgs, ... }:
let 
  userdb-path = "/var/lib/calibre-users";
in
{
  imports = [
    ./caddy.nix
  ];
  options = {
    calibre.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Calibre";
      default = false;
    };
  };

  config = lib.mkIf (config.calibre.enable) {
    # Need to generate file with `calibre-server --userdb /srv/calibre/users.sqlite --manage-users` 
    # if it doesn't exist already. Also copy usersdb into /var/lib/users.sqlite during installation
    system.activationScripts.script.text = ''
      mkdir ${userdb-path}
      chown calibre-server:calibre-server ${userdb-path}
      chmod 755 ${userdb-path}
    '';

    # -------------------- 
    # Calibre Configuration
    # -------------------- 
    services.calibre-server = {
      enable = true;
      port = 8080;
      host = "127.0.0.1";
      auth = {
        enable = true;
        mode = "basic";
        userDb = "${userdb-path}/users.sqlite";
      };
      openFirewall = false;
      libraries = [ "/var/lib/calibre-server" ];
    };
    # -------------------- 
    # Caddy SSL Cert
    # -------------------- 
    caddy = {
      enable = true;
      port = 8080;
    };
  };
}
