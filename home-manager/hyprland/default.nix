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
    ./noctalia.nix
  ];
  fuzzel.enable = enable-hyprland;
  waybar.enable = enable-hyprland;
  hyprland-profile.enable = enable-hyprland;
  noctalia.enable = enable-hyprland;
}
