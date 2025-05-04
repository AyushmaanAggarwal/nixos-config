{ inputs, outputs, config, lib, pkgs, modulesPath, ... }:
let
  hostname = "adguard";
in
{ 
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  adguard.enable = true;
}
