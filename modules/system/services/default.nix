{ inputs, config, lib, pkgs, ... }:
{
  imports = [ 
    ./backup.nix
    ./earlyoom.nix
  ];
}
