{
  ...
}:
{
  imports = [
    ./backup
    ./earlyoom.nix
    ./sops-nix.nix
    ./btrfs-scrub.nix
    ./polkit.nix
    ./notify.nix
    ./backlight.nix
  ];
  btrfs-scrub.enable = false;
}
