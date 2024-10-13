# Backup Services
{ config, pkgs, ... }:
{
  # --- Syncthing ---
  services.syncthing = {
    enable = true;
    user = "ayushmaan";
    # Default folder for new synced folders
    dataDir = "/home/ayushmaan/Documents";
    # Folder for Syncthing's settings and keys
    configDir = "/home/ayushmaan/.local/state/syncthing";#.config/syncthing";
  };

  # --- Restic ---
  users.users.ayushmaan.packages = with pkgs; [
      restic
  ];

  users.users.restic = {
    isNormalUser = true;
  };
  
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

}
