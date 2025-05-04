{ inputs, config, lib, pkgs, modulesPath, ... }:
{ 
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = "backup";
}
