{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  hostname = "etebase";
in {
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  etebase.enable = true;
}
