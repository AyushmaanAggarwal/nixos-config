# Applications
{ config, pkgs, ... }:
{
  # -------------------- 
  # Various services
  # -------------------- 
  services.thermald.enable = true;
  services.printing.enable = true; # Enable CUPS to print documents.
  services.blueman.enable = true;
  services.flatpak.enable = true; 
  services.tailscale.enable = true;

  # -------------------- 
  # Security and Hardware
  # -------------------- 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # -------------------- 
  # Sound
  # -------------------- 
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
    # kdeconnect.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ayushmaan = { 
    isNormalUser = true; description = "Ayushmaan Aggarwal"; 
    extraGroups = [ "networkmanager" "wheel" ]; 
    packages = with pkgs; [
      # GUI Applications
      # vlc
      slack #unfree
      kitty
      spotify #unfree
      inkscape
      darktable
      vscodium
      thunderbird
      signal-desktop
      # bitwarden-desktop
      # onlyoffice-desktopeditors
      ## Academic
      # mathematica
      xournalpp 
      zotero
      calibre

      # Terminal Applications
      fd
      bws #unfree
      unzip
      rclone
      nodejs
      ## Python
      python3
      #python312Packages.pip
      conda
      numbat
      ## Notes
      neovim
      quarto
      pandoc
      ripgrep
      marksman
      tree-sitter
      texliveFull
      lua-language-server
      ## Monitoring
      htop
      powertop
      onefetch
      fastfetch
      
    ];
  };

  fonts.packages = with pkgs; [
      jetbrains-mono # Font
      nerd-fonts.fira-code
  ];

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [ 
    vim
    git
    gcc
    wget
  ];

}

