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
    ./kitty.nix
    ./zathura.nix
  ];
}
