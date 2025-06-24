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
}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

}
