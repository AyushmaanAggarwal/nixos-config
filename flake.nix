{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in { 
      nixosConfigurations.ayu = nixpkgs.lib.nixosSystem {
        inherit system;

        # Tag each generation with Git hash 
        system.configurationRevision = 
          if (inputs.self ? rev) 
          then inputs.self.shortRev 
          else throw "Refusing to build from a dirty Git tree!"; 
        system.nixos.label = "GitRev.${config.system.configurationRevision}.Rel.${config.system.nixos.release}";

        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ./configuration.nix
          ./applications.nix
        ];
      };
    };
}
