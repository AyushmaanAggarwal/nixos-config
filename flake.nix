{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: 
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
      overlays = import ./overlays {inherit inputs;};

      nixosConfigurations = {
        thegram = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/thegram/configuration.nix ];
        };
      };
    };
}
