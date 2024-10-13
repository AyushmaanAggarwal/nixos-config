{ config, pkgs, home-manager, ... }:

{

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
