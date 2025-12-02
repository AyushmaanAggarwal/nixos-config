{ ... }:
{
  imports = [
    ./package-manager.nix
    ./scripts.nix
    ./sops-nix.nix
    ./ssh.nix
    ./users.nix
  ];
}
