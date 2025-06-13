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
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit
        inputs
        hostname
        username
        desktop
        system
        ;
    };
    
    users.${username} = ./home.nix;

  };
}
