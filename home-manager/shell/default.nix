{pkgs, ...}:
{
  imports = [
    ./zsh.nix
    ./numbat.nix
    ./direnv.nix
  ];
}
