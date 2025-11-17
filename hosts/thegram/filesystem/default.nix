{ ... }:
{
  imports = [
    ./zfs-disko.nix
    ./btrfs.nix
  ];

  # fix sops not finding home at boot
  fileSystems."/home".neededForBoot = true;
}
