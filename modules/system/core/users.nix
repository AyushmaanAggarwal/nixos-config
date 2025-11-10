{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}:
let
  secrets-file = ../../../secrets/thegram/hashed-passwords.yaml;
in
{
  sops.secrets.root-password = {
    owner = "root";
    group = "root";
    mode = "0400";
    sopsFile = secrets-file;
  };

  sops.secrets.user-password = {
    owner = "${username}";
    group = "users";
    mode = "0400";
    sopsFile = secrets-file;
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
    ];
    hashedPasswordFile = config.sops.secrets.user-password.path;
  };

}
