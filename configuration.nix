{ config, pkgs, ... }:

{ imports =
    [ 
      ./hardware-configuration.nix 
      ./systemd-configuration.nix
    #./applications.nix
      ./network-configuration.nix
      ./home-manager/configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];

  # Create backup of system
  # system.copySystemConfiguration = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Collect garbage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 60d";
  };


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

