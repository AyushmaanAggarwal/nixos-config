{
  desktop,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./kde.nix
    ./gnome.nix
    ./cosmic.nix
  ];

  ${desktop}.enable = true;

  # Assume wayland desktop enviroment
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
