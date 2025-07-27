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
    "acpi_backlight=native"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
    consoleMode = "max";
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
