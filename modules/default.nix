# Main Configuration
{ inputs, config, pkgs, ... }:

{ 
  imports =
    [ 
      ./applications.nix

      ./desktop/default.nix

      ./system/core/default.nix
      ./system/systemd/default.nix
      ./system/services/default.nix
      ./system/hardware-configuration.nix

      inputs.sops-nix.nixosModules.sops
    ];
}
