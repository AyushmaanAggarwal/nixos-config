{
  inputs,
  config,
  lib,
  pkgs,
  desktop,
  hostname,
  system,
  username,
  ...
}: 
{
  imports = [ 
    ./fuzzel.nix
    ./waybar/default.nix
  ];
  fuzzel.enable = ("${desktop}" == "hyprland");
  waybar.enable = ("${desktop}" == "hyprland");
}
