# Applications
{ config, pkgs, ... }:
{
  # -------------------- 
  # Various services
  # -------------------- 
  services.thermald.enable = true;
  powerManagement.enable = true;
  services.flatpak.enable = true; 
  services.tailscale = {
    enable = true;
    package = pkgs.stable.tailscale;
  };
  services.udisks2.enable = true; # for calibre kindle connection
  services.etesync-dav.enable = true;
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 10; # <15% free
    freeMemKillThreshold = 5; # <15% free
    freeSwapThreshold = 10;
    freeSwapKillThreshold = 10;
  };
  #virtualisation.waydroid.enable = true;
  programs.singularity = {
    enable = true;
    package = pkgs.apptainer;
  };
  

  services.printing = {
    enable = true; # Enable CUPS to print documents.
    #drivers = [ pkgs.cnijfilter2 ]; # Canon Pixma drivers
  };

  # -------------------- 
  # Security and Hardware
  # -------------------- 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  services.blueman.enable = true;
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
    zsh.enable = true;
    adb.enable = true;
    steam.enable = true;
    #firefox.enable = true;
    thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
     };
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
      stable.signal-desktop
      # bitwarden-desktop
      # onlyoffice-desktopeditors
      ## Academic
      # mathematica
      xournalpp 
      zotero
      calibre

      # Terminal Applications
      fd
      gdu
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

