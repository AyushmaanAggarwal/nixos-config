# Applications
{
  outputs,
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    outputs.overlays.stable-packages
  ];

  # --------------------
  # Various services
  # --------------------
  services.udisks2.enable = true; # for calibre kindle connection

  services.printing = {
    enable = true; # Enable CUPS to print documents.
  };

  # Install progams
  programs = {
    zsh.enable = true;
    adb.enable = true;
    thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
    };

    # Gaming
    steam = {
      enable = true;
      gamescopeSession.enable = true; # For gamescope
    };
    gamescope = { # Steam Virtualized Compositor
      enable = true;
      capSysNice = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ayushmaan = {
    isNormalUser = true;
    description = "Ayushmaan Aggarwal";
    extraGroups = ["networkmanager" "wheel" "adbusers"];
    packages = with pkgs; [
      # GUI Applications
      mpv
      lutris
      slack #unfree
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
      psmisc # For killall command
      ## Monitoring
      htop
      powertop
      onefetch
      fastfetch

      # Nix Packages
      pkgs.nixfmt-rfc-style
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
