# Main Configuration
{ inputs, config, pkgs, ... }:

{ 
  imports =
    [ 
      ./applications.nix

      ./desktop

      ./system/core
      ./system/systemd
      ./system/services
      ./system/hardware-configuration.nix

      inputs.sops-nix.nixosModules.sops
    ];
}
