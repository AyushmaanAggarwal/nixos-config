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
  programs.distrobox = {
    enable = true;
    containers = {
      matlab = {
        image = "ubuntu:24.04";
        entry = true;
      };
    };
  };
}
