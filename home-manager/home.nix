{ inputs, config, pkgs, home-manager, ... }:
{
  imports = [ 
    inputs.home-manager.nixosModules.home-manager
    ./zsh.nix
    ./theme.nix
    ./numbat.nix
    ./firefox.nix
  ];

  # Home Manager Package Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.ayushmaan = { pkgs, ... }: {
    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
