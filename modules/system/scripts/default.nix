{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./system-updater.nix
  ];
}
