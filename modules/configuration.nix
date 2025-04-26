# Main Configuration
{ inputs, config, pkgs, ... }:

{ 
  imports =
    [ 
      ./applications.nix

      # --- Desktop Environment ---
      #./desktop/cosmic.nix
      #./desktop/hyprland.nix
      ./desktop/kde.nix # UNTESTED
      #./desktop/gnome.nix

      # --- System Configuration ---
      ./system/systemd/configuration.nix
      ./system/hardware-configuration.nix 
      ./system/network-configuration.nix
      ./system/environment-configuration.nix
      ./system/nix-package-configuration.nix
      ./system/backup.nix
    ];

  # Bootloader.
  boot.kernelParams = [ "quiet" "acpi_backlight=native" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true; 
    editor = false;
    consoleMode = "max";
  };

  # Add swapfile
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
    randomEncryption.enable = true;
  } ];

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly 
  # fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man 
  # configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; 

}

