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
    ./services/calibre-server.nix
    ./services/etesync.nix
    ./services/immich.nix
    ./services/nextcloud.nix
    ./services/immich.nix
    #./services/photoprism.nix # Untested
    ./services/uptime-kuma.nix
    ./services/tailscale.nix
    ./services/changedetection.nix
    ./services/ntfy-sh.nix
    ./services/mealie.nix
  ];
}
