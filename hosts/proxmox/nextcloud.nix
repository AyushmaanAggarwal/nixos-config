{ inputs, outputs, config, lib, pkgs, modulesPath, ... }:
let
  hostname = "nextcloud";
in
{ 
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  nextcloud.enable = true;
}
