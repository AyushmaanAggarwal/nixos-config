{
  desktop,
  ...
}:
let
  enable-hyprland = "${desktop}" == "hyprland";
in
{
  imports = [
    ./noctalia
    ./fuzzel.nix
    ./profile.nix
  ];
  fuzzel.enable = enable-hyprland;
  hyprland-profile.enable = enable-hyprland;
  noctalia.enable = enable-hyprland;
}
