{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  hostname = "uptime";
in {
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  uptime.enable = true;
}
