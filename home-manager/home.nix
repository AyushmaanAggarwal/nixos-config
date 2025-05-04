{ config, pkgs, home-manager, ... }:
{
  imports = [ 
    home-manager.nixosModules.home-manager
  ];
  # Home Manager Package Configuration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.ayushmaan = { pkgs, ... }: {
    imports = [
      ./zsh.nix
      ./theme.nix
    ];

    # home.packages = [ ];
    
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
