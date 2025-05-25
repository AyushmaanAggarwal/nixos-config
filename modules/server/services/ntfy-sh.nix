{ inputs, config, lib, pkgs, ... }:
{
  options = {
    ntfy-sh.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Ntfy-sh";
      default = false;
    };
  };
  config = lib.mkIf (config.ntfy-sh.enable) {
    # -------------------- 
    # Ntfy Configuration
    # -------------------- 
    services.ntfy-sh = {
      enable = true;
      user = "ntfy-sh";
      group = "ntfy-sh";
      settings = {
        base-url = "ntfy.tail590ac.ts.net";
        listen-http = ":8290";
      };
    };

    # -------------------- 
    # Caddy SSL Cert
    # -------------------- 
    caddy = {
      enable = true;
      port = 8290;
    };

  };
}
