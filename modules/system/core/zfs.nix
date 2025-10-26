# This is based off of
# https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html
# https://wiki.nixos.org/wiki/ZFS
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  hostID = "4303477a"; # generate using "head -c4 /dev/urandom | od -A none -t x4"

  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;

  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  # Bootloader
  boot.kernelPackages = latestKernelPackage;
  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ]; # 4 GiB of arc
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.grub.zfsSupport = true;
  boot.zfs = {
    passwordTimeout = 300; # Wait 5 minutes on boot for password
    forceImportRoot = false;
    # extraPools = [ "root" "root/home" "root/nix" ];
  };

  security.pam.zfs = {
    enable = true; # Enable unlocking home dataset at login
    noUnmount = false;
    homes = "root/home";
  };

  # Maintenance
  # services.zfs.autoReplication = {
  #   enable = true;
  #   username = "ayushmaan";
  #   host = "pve";
  #   identityFilePath = "/home/ayushmaan/.ssh/id_ed25519";
  #   followDelete = true;
  #   localFilesystem = "root/home";
  # };

  # services.zfs.autoScrub = {
  #   enable = true;
  #   interval = "monthly";
  #   pools = [ ]; # scrub all pools
  # };

  # services.zfs.autoSnapshot = {
  #   enable = true;
  #   frequent = 4;
  #   hourly = 24;
  #   daily = 7;
  #   weekly = 4;
  #   monthly = 2;
  # };

  # services.zfs.trim = {
  #   enable = true;
  #   interval = "weekly";
  # };

  # Notification Settings
  services.zfs.zed = {
    settings = {
      # send notification if scrub succeeds
      ZED_NOTIFY_VERBOSE = true;

      ZED_NTFY_TOPIC = "thegram";
      ZED_NTFY_URL = "https://ntfy.tail590ac.ts.net/";
      # ZED_NTFY_ACCESS_TOKEN=""
    };
  };

  networking.hostId = hostID;
}
