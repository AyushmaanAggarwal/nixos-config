# Detect Changes in Websites using changedetection-io
{ inputs, config, lib, pkgs, ... }:
{
  options = {
    changedetection.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Website Change Detection";
      default = false;
    };
  };
  config = lib.mkIf (config.changedetection.enable) {
    services.changedetection-io = {
      enable = true;
      port = 5000;
      listenAddress = "127.0.0.1";
      user = "changedetection-io";
      group = "changedetection-io";
      behindProxy = true;
      #datastorePath = "/var/lib/changedetection-io";
      #environmentFile = "/run/secrets/changedetection-io.env";

      webDriverSupport = false; # Due to memory leak
      playwrightSupport = false;
      chromePort = 4444;
    };
    
    # -------------------- 
    # Caddy SSL Cert
    # -------------------- 
    caddy = {
      enable = true;
      port = 5000;
    };
 
  };
}
