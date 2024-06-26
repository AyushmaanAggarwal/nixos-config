{ config, pkgs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix 
      ./systemd-configuration.nix
      ./applications.nix
      <home-manager/nixos>
      ./home-manager/configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ 
    # "acpi_backlight=native"
  ];

  # Create backup of system
  system.copySystemConfiguration = true;

  # Networking
  networking.hostName = "ayu"; # Define your hostname.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary networking.proxy.default = "http://user:password@proxy:port/"; networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = { LC_ADDRESS = "en_US.UTF-8"; LC_IDENTIFICATION = "en_US.UTF-8"; LC_MEASUREMENT = "en_US.UTF-8"; LC_MONETARY = "en_US.UTF-8"; LC_NAME = "en_US.UTF-8"; 
    LC_NUMERIC = "en_US.UTF-8"; LC_PAPER = "en_US.UTF-8"; LC_TELEPHONE = "en_US.UTF-8"; LC_TIME = "en_US.UTF-8";
  };

  home-manager.backupFileExtension = "backup";
  
  # Some programs need SUID wrappers, can be configured further or are started in user sessions. programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall altogether. 
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database versions on your system were taken. It‘s perfectly 
  # fine and recommended to leave this value at the release version of the first install of this system. Before changing this value read the documentation for this option (e.g. man 
  # configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; 

}

