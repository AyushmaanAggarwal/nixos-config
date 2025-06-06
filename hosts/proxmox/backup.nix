{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./proxmox.nix
    ../../modules/server/default.nix
  ];
  networking.hostName = "backup";

  users.users.proxmox.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEa53AGMV87VUquUKyQ2NlqmZiN7OVV438VLUe6hYJU2"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOmhA7UsDVaSC7A+CLcKnKkYuSjgObaauAFJWdjHmK1X ayushmaan@thegram"
  ];
}
