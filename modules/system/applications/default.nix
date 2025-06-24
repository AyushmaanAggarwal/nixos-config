{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}: {
  imports = [ 
    ./applications.nix
    ./virtualization.nix
  ];
}
