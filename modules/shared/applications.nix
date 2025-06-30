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

    # Coding
    git

    # Other
    wget
    bash

    # System info
    fastfetch
    htop
  ];
}
