{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #nixpkgs.follows = "nixos-cosmic/nixpkgs-stable";
    #nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  # outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-cosmic}@inputs: 
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager}@inputs: 
    let
      system = "x86_64-linux";
      system.configurationRevision = let self = inputs.self; in self.shortRev or self.dirtyShortRev or self.lastModified or "unknown";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in { 
      nixosConfigurations.ayu = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # nix.settings = {
            #   substituters = [ "https://cosmic.cachix.org/" ];
            #   trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            # };
          }          
          # nixos-cosmic.nixosModules.default
          ./configuration.nix
          ./applications.nix
        ];
      };
    };
}
