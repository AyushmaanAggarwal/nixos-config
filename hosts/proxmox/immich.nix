{ inputs, outputs, config, lib, pkgs, modulesPath, ... }:
let
  hostname = "immich";
in
{ 
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  immich.enable = true;
}
