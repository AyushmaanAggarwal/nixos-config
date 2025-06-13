{
  inputs,
  config,
  pkgs,
  lib,
  home-manager,
  desktop,
  hostname,
  system,
  username,
  ...
}: 
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home Manager Package Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.${username} = {
    pkgs,
    desktop,
    hostname,
    system,
    username,
    ...
    }: {
      imports = [
        ./theme.nix
        ./kitty.nix
        ./shell/default.nix
        ./hyprland/default.nix
        ./firefox/default.nix
      ];

      home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
