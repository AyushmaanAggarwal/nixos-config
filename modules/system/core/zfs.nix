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
  # Bootloader.
  boot.kernelPackages = latestKernelPackage;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = hostID;
}
