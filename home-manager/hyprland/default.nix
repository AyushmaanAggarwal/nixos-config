{
  desktop,
  ...
}:
let
  enable-hyprland = "${desktop}" == "hyprland";
in
{
  imports = [
    ./fuzzel.nix
    ./waybar/default.nix
    ./profile.nix
  ];
  fuzzel.enable = enable-hyprland;
  waybar.enable = enable-hyprland;
  hyprland-profile.enable = enable-hyprland;
}
