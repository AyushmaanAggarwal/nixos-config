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
}: {
  imports = [
    ./theme.nix
    ./kitty.nix
    ./shell/default.nix
    ./hyprland/default.nix
    ./firefox/default.nix
  ];

  home.stateVersion = "24.05";
}
