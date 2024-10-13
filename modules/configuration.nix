# Main Configuration
{ inputs, config, pkgs, ... }:

{ 
  imports =
    [ 
      ./applications.nix

      # --- Desktop Environment ---
      #./desktop/cosmic.nix
      ./desktop/hyprland.nix

      # --- System Configuration ---
      ./system/hardware-configuration.nix 
      ./system/systemd-configuration.nix
      ./system/network-configuration.nix
      ./system/environment-configuration.nix
      ./system/nix-package-configuration.nix
    ];

  # Bootloader.
  boot.kernelParams = [ "quiet" ];
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

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { 
    LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8"; 
    LC_MEASUREMENT = "en_US.UTF-8"; 
    LC_MONETARY = "en_US.UTF-8"; 
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8"; 
    LC_PAPER = "en_US.UTF-8"; 
    LC_TELEPHONE = "en_US.UTF-8"; 
    LC_TIME = "en_US.UTF-8";
  };

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly 
  # fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man 
  # configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; 

}

