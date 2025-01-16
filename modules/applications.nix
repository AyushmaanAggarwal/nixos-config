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
  services.udisks2.enable = true; # for calibre kindle connection
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 15; # <15% free
    freeMemKillThreshold = 5; # <15% free
    freeSwapThreshold = 40;
    freeSwapKillThreshold = 20;
  };
  virtualisation.waydroid.enable = true;
  programs.singularity = {
    enable = true;
    package = "apptainer";
  };
  

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
  services.pulseaudio.enable = false; 
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
    adb.enable = true;
    # kdeconnect.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ayushmaan = { 
    isNormalUser = true; description = "Ayushmaan Aggarwal"; 
    extraGroups = [ "networkmanager" "wheel" "adbusers" ]; 
    packages = with pkgs; [
      # GUI Applications
      mpv
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
      jetbrains-mono
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

