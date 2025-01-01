{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    #nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nixpkgs.follows = "nixos-cosmic/nixpkgs";
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  #outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-master, home-manager, nixos-cosmic}@inputs: 
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager }@inputs: 
    let
      system = "x86_64-linux";
      overlay-pkgs = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        # master = import nixpkgs-master {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };
    in { 
      nixosConfigurations.ayu = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-pkgs ]; })
          # nixos-cosmic.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }          
          ./home-manager/configuration.nix
          ./modules/configuration.nix
          {
            _module.args = {
              inherit inputs;
            };
          }
        ];
      };
    };
}
