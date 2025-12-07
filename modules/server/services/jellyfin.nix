{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [

  ];
  options = {
    jellyfin.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable jellyfin";
      default = false;
    };
  };
  config = lib.mkIf (config.jellyfin.enable) {
    users.users.proxmox.extraGroups = [ "jellyfin" ];
    services.jellyfin = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 8096;
    };

  };
}
