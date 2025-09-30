{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}:
{
  imports = [
    ./firefox
    ./kitty.nix
    ./zathura.nix
  ];
}
