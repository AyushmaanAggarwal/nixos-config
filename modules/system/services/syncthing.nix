# Backup Services
{
  config,
  pkgs,
  username,
  ...
}:
{
  # --- Syncthing ---
  services.syncthing = {
    enable = true;
    user = "${username}";
    # Default folder for new synced folders
    dataDir = "/home/${username}/Documents";
    # Folder for Syncthing's settings and keys
    configDir = "/home/${username}/.local/state/syncthing"; # .config/syncthing";
  };
}
