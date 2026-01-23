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
  services.printing.enable = true; # Enable CUPS to print documents.
  services.ollama.enable = true;

  # Install progams
  programs = {
    zsh.enable = true;
    thunderbird.enable = true;
    partition-manager.enable = true;
    steam.enable = true; # Not free
  };

  # Set user applications
  users.users.${username} = {
    packages = with pkgs; [
      # GUI Applications
      slack # unfree
      spotify # unfree
      inkscape
      # darktable # Disable due to broken package
      signal-desktop
      bitwarden-cli
      libreoffice-fresh
      ## Academic
      xournalpp
      zotero

      # Terminal Applications
      fd
      mpv
      gdu
      tmux
      rsync
      rclone
      psmisc # For killall command
      android-tools

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
