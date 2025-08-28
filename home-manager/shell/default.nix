{ pkgs, lib, ... }:
{
  imports = [
    ./zsh.nix
    ./numbat.nix
    ./direnv.nix
    ./distrobox.nix
  ];
}
