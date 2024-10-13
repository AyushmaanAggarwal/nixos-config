# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by 
# running ‘nixos-help’).

{ config, pkgs, ... }:
{
  # -------------------- 
  # Various services
  # -------------------- 
  services.printing.enable = true; # Enable CUPS to print documents.
  services.blueman.enable = true;
  services.flatpak.enable = true; 
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
  services.tailscale.enable = true;
  services.syncthing = {
    enable = true;
    user = "ayushmaan";
    dataDir = "/home/ayushmaan/Documents";    # Default folder for new synced folders
    configDir = "/home/ayushmaan/.local/state/syncthing";#.config/syncthing";   # Folder for Syncthing's settings and keys
  };

  # -------------------- 
  # Various security and hardware
  # -------------------- 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false; 
  security.rtkit.enable = true; 
  services.pipewire = {
    enable = true; 
    pulse.enable = true;
    alsa.enable = true; 
    alsa.support32Bit = true; 
  };

  # Install progams
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    steam.enable = true;
    kdeconnect.enable = true;
    hyprland.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ayushmaan = { 
    isNormalUser = true; description = "Ayushmaan Aggarwal"; 
    extraGroups = [ "networkmanager" "wheel" ]; 
    packages = with pkgs; [
      # System Applications
      hyprlock
      hyprpaper
      waybar
      dunst
      pavucontrol

      # GUI Applications
      thunderbird
      nautilus
      vlc
      slack
      kitty
      fuzzel
      spotify
      inkscape
      darktable
      vscodium
      signal-desktop
      bitwarden-desktop
      onlyoffice-desktopeditors
      ## Academic
      mathematica
      xournalpp 
      zotero
      calibre

      # Terminal Applications
      restic
      fd
      tlp
      bws
      unzip
      rsync
      rclone
      nodejs
      ## Python
      python3
      python312Packages.pip
      conda
      ## Notes
      neovim
      quarto
      pandoc
      marksman
      tree-sitter
      texliveFull
      lua-language-server
      ## Monitoring
      htop
      powertop
      onefetch
      fastfetch
      ## Screenshots
      grim
      slurp
      wl-clipboard

      # Random
      jetbrains-mono # Font
    ];
  };

  users.users.restic = {
    isNormalUser = true;
  };
  
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # virtualisation = {
  #   containers.enable = true;
  #   podman.enable=true;
  # };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [ 
    vim
    git
    gcc
    wget
  ];

}

