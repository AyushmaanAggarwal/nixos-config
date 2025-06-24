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
        additional_packages = "xcb alsa-lib libnss3 libgtk2.0-0";
        exported_apps="Matlab";
        exported_bins="/home/ayushmaan/Applications/matlab/bin/matlab";
        exported_bins_path="/home/ayushmaan/Applications/matlab/bin";
      };
    };
  };
}
