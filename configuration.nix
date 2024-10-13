{ inputs, config, pkgs, ... }:

{ 
  imports =
    [ 
      ./hardware-configuration.nix 
      ./systemd-configuration.nix
      ./network-configuration.nix
      ./environment-configuration.nix
      ./home-manager/configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];

  # Add swapfile
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16*1024;
    randomEncryption.enable = true;
  } ];

  # Create backup of system
  # system.copySystemConfiguration = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatically update system
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
  };

  # system.configurationRevision = inputs.self.shortRev or inputs.self.dirtyShortRev or inputs.self.lastModified or "unknown";
  system.nixos.label = (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags)) + config.system.nixos.version + "-SHA:${self.rev}";
  # Collect garbage
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
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

