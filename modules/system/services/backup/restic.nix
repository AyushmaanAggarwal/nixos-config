# Backup Services
{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./restic-etc.nix
    ./restic-systemd.nix
  ];

  users.users.ayushmaan.packages = with pkgs; [
    restic
    python3Full
    python313Packages.requests
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
