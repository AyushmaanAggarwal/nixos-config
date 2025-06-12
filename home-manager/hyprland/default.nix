{ inputs, config, lib, pkgs, ... }:
{
  imports = [ 
    ./fuzzel.nix
    ./waybar/default.nix
  ];
}
