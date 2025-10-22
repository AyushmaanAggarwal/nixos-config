{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
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
  boot.kernelParams = [
    "quiet"
  ];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelPackages = latestKernelPackage;
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 5;
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "max";
    };
  };

  # Add swapfile
  # swapDevices = [
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 16 * 1024;
  #     randomEncryption.enable = true;
  #   }
  # ];
}
