{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  # Bootloader.
  boot.kernelParams = [
    "quiet"
  ];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
