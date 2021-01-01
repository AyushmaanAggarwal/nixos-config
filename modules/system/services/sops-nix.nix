# Applications
{
  inputs,
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
    age.generateKey = true;
  };
}
