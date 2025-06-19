# Backup Services
{
  config,
  pkgs,
  ...
}: {
  # --- Syncthing ---
  services.syncthing = {
    enable = true;
    user = "ayushmaan";
    # Default folder for new synced folders
    dataDir = "/home/ayushmaan/Documents";
    # Folder for Syncthing's settings and keys
    configDir = "/home/ayushmaan/.local/state/syncthing"; # .config/syncthing";
  };
}
