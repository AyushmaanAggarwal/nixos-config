{ inputs, outputs, config, pkgs, ... }:

{ 
  imports =
    [ 
      ./applications.nix
      ./developer-enviroment.nix
      
      ./core/default.nix
      ./systemd/default.nix
      ./services/default.nix
      ./desktop/default.nix

      #inputs.sops-nix.nixosModules.sops
    ];
}
