{
  inputs,
  config,
  pkgs,
  lib,
  home-manager,
  desktop,
  hostname,
  system,
  username,
  ...
}:
{
  imports = [
    ./theme.nix
    ./gui
    ./shell
    ./hyprland
    ./firefox
  ];

  home.stateVersion = "24.05";
}
