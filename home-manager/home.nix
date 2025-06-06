{
  inputs,
  config,
  pkgs,
  lib,
  home-manager,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Home Manager Package Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.ayushmaan = {pkgs, ...}: {
    imports = [
      ./shell/default.nix
      ./theme.nix
      ./firefox/default.nix
    ];

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
