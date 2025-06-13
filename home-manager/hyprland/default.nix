{
  inputs,
  config,
  lib,
  pkgs,
  desktop,
  username,
  ...
}: 
let
  enable-hyprland = ("${desktop}" == "hyprland");
in
{
  imports = [ 
    ./fuzzel.nix
    ./waybar/default.nix
  ];
  fuzzel.enable = enable-hyprland;
  waybar.enable = enable-hyprland;
}
