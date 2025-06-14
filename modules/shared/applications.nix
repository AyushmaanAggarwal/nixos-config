{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Editors
    vim
    nano

    # Coding
    git
    gcc

    # Other
    wget
    bash

    # System info
    fastfetch
    htop
  ];
}
