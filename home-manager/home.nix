{ inputs, config, pkgs, home-manager, ... }:
{
  imports = [ 
    inputs.home-manager.nixosModules.home-manager
  ];
  # Home Manager Package Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users.ayushmaan = { pkgs, ... }: {
    imports = [
      ./zsh.nix
      ./theme.nix
      ./firefox.nix
    ];

    # home.packages = [ ];
    
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  home-manager.backupFileExtension = "backup";
}
