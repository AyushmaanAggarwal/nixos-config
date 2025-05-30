{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
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
        base-url = "https://ntfy.tail590ac.ts.net";
        listen-http = "127.0.0.1:8290";
        #attachment-cache-dir = "/var/lib/private/ntfy-sh/attachments";
        #auth-file = "/var/lib/private/ntfy-sh/user.db";
        #cache-file = "/var/lib/private/ntfy-sh/cache-file.db";
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
