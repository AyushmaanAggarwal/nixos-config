{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  hostname = "mealie";
in {
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  mealie.enable = true;
}
