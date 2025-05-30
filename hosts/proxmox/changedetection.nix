{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  hostname = "changedetection";
in {
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  changedetection.enable = true;
}
