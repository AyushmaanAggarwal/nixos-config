# Main Configuration
{ ... }: {
  imports = [
    # --- System Configuration ---
    ./common/users.nix
    ./common/nix-package-configuration.nix
    ./common/scripts.nix
    ./services/ssh.nix

    # --- All Applications ---
    ./services/adguard.nix
    ./services/calibre.nix
    ./services/changedetection.nix
    ./services/etebase.nix
    #./services/gitlab.nix
    ./services/grafana.nix
    ./services/immich.nix
    ./services/mealie.nix
    ./services/nextcloud.nix
    ./services/ntfy.nix
    #./services/ollama.nix
    ./services/tailscale.nix
    ./services/uptime.nix
    ./services/jellyfin.nix
    ./services/glance.nix
  ];
}
