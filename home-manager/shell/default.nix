{ pkgs, lib, ... }:
{
  imports = [
    # Shells
    ./zsh.nix
    ./numbat.nix

    # Tools
    ./fd.nix
    ./tmux.nix
    #./git.nix
    ./direnv.nix
    ./distrobox.nix
  ];
}
