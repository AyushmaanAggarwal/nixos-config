{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #nixpkgs.follows = "nixos-cosmic/nixpkgs-stable";
    #nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  # outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-cosmic}@inputs: 
  outputs = { self, nixpkgs, home-manager}@inputs: 
    let
      system = "x86_64-linux";
    in { 
      nixosConfigurations.ayu = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; }; # this is the important part
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }          
          ./home-manager/configuration.nix
          ./modules/configuration.nix
        ];
      };
    };
}
