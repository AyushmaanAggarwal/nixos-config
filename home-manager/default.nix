{
  inputs,
  config,
  pkgs,
  lib,
  home-manager,
  desktop,
  hostname,
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
        ;
    };

    users.${username} = {
      imports = [
        ./gui
        ./shell
        ./hyprland
        ./theme.nix
      ];

      home.stateVersion = "24.05";
    };

  };
}
