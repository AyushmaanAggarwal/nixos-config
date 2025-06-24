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
        additional_packages = "xcb libasound2t64 libnss3 libgtk2.0-0 libxft2";
        init_hooks = ''export QT_QPA_PLATFORM=xcb'';
        exported_apps="Matlab";
        exported_bins="/home/ayushmaan/Applications/matlab/bin/matlab";
        exported_bins_path="/home/ayushmaan/Applications/matlab/bin";
      };
    };
  };
}
