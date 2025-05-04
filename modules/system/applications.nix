# Applications
{ outputs, config, pkgs, ... }:
{
  nixpkgs.overlays = [
    outputs.overlays.stable-packages 
  ];
 
  # -------------------- 
  # Various services
  # -------------------- 
  services.thermald.enable = true;
  powerManagement.enable = true;
  services.udisks2.enable = true; # for calibre kindle connection
  
  services.printing = {
    enable = true; # Enable CUPS to print documents.
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
      sops
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

