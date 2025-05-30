# Applications
{
  inputs,
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    age.generateKey = true;
  };
}
