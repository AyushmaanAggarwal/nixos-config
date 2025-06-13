# Main Configuration
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # --- System Configuration ---
    ./common/general-applications.nix
    ./common/nix-package-configuration.nix
    ./common/scripts.nix
    ./services/ssh.nix

    # --- All Applications ---
    ./services/adguard.nix
    ./services/calibre.nix
    ./services/etebase.nix
    ./services/immich.nix
    ./services/nextcloud.nix
    ./services/immich.nix
    #./services/photoprism.nix # Untested
    ./services/uptime.nix
    ./services/tailscale.nix
    ./services/changedetection.nix
    ./services/ntfy.nix
    ./services/mealie.nix
  ];
}
