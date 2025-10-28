{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./restic.nix
    ./syncthing.nix
  ];
}
