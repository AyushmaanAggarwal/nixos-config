{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./caddy.nix
  ];

  options = {
    immich.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Immich";
      default = false;
    };
  };

  config = lib.mkIf (config.immich.enable) {
    # --------------------
    # Immich Service
    # --------------------
    services.immich = {
      enable = true;
      package = pkgs.unstable.immich;
      host = "127.0.0.1";
      port = 8283;
    };

    # --------------------
    # Hardware Video Transcoding
    # --------------------
    users.users.immich.extraGroups = [
      "video"
      "render"
    ];
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # For older processors. LIBVA_DRIVER_NAME=i965
      ];
    };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    }; # Optionally, set the environment variable

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 8283;
    };
  };
}
