{
  ...
}:
{
  imports = [
    ./sops-nix.nix
    ./btrfs-scrub.nix

    # System Services
    ./notify.nix
    ./polkit.nix
    ./earlyoom.nix
    ./backlight.nix

    # Backups
    ./restic.nix
    ./syncthing.nix
  ];
  btrfs-scrub.enable = false;
}
