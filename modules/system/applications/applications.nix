# Applications
{
  outputs,
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  nixpkgs.overlays = [
    outputs.overlays.stable-packages
  ];

  # --------------------
  # Various services
  # --------------------
  services.udisks2.enable = true; # for calibre kindle connection

  services.printing.enable = true; # Enable CUPS to print documents.

  services.ollama.enable = true;

  # Install progams
  programs = {
    zsh.enable = true;
    adb.enable = true;
    thunderbird.enable = true;
    partition-manager.enable = true;

    # Gaming
    steam.enable = true; # Not free
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
    ];
    packages = with pkgs; [
      # GUI Applications

      slack # unfree
      spotify # unfree
      inkscape
      # darktable # Disable due to broken package
      signal-desktop
      # bitwarden-desktop
      libreoffice-fresh
      ## Academic
      xournalpp
      zotero
      # calibre
      # mathematica # unfree

      # Terminal Applications
      fd
      mpv
      gdu
      tmux
      rsync
      sshfs
      rclone
      psmisc # For killall command
      ## Monitoring
      htop
      powertop
      onefetch
      fastfetch
    ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "slack"
      "spotify"
      "bws"
      "steam"
      "steam-unwrapped"
    ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
  ];
}
