{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # nixpkgs.follows = "nixos-cosmic/nixpkgs";
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  #outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-master, home-manager, nixos-cosmic}@inputs: 
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, sops-nix }@inputs: 
    let
      system = "x86_64-linux";
      overlay-pkgs = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in { 
      nixosConfigurations.thegram = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-pkgs ]; })
          ./modules/configuration.nix
          ./home-manager/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }          
          sops-nix.nixosModules.sops
        ];
      };
    };
}
