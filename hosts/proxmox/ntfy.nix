{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  hostname = "ntfy";
in {
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = hostname;
  caddy.hostname = hostname;
  ntfy-sh.enable = true;
}
