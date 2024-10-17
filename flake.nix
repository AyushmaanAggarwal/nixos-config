{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #nixpkgs.follows = "nixos-cosmic/nixpkgs-stable";
    #nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  # outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-cosmic}@inputs: 
  outputs = { self, nixpkgs, nixpkgs-stable, home-manager}@inputs: 
    let
      system = "x86_64-linux";
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in { 
      nixosConfigurations.ayu = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          {
            nix.settings = {
              substituters = [
                "https://hyprland.cachix.org"
                "https://cache.nixos.org/"
              ];
              trusted-public-keys = [
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              ];
            };
          }
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
