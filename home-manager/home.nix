{
  inputs,
  config,
  pkgs,
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
      ./zsh.nix
      ./theme.nix
      ./numbat.nix
      ./firefox/default.nix
    ];

    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
