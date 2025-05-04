{ inputs, config, lib, pkgs, ... }:
{
  imports = [ 
    ./boot.nix
    ./network.nix
    ./package-manager.nix
    ./security.nix
    ./sound.nix
  ];
}
