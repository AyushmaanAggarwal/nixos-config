{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager, ... }@inputs: 
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
      overlays = import ./overlays {inherit inputs;};

      nixosConfigurations = {
        # Primary System
        thegram = nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/thegram/configuration.nix ];
        };

        # Server Containers
        backup = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/proxmox/backup.nix];
        };

        etebase = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/proxmox/etebase.nix ];
        };

        adguard = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/proxmox/adguard.nix ];
        };

        immich = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/proxmox/immich.nix ];
        };

        nextcloud = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/proxmox/nextcloud.nix ];
        };

        uptime = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs outputs;};
          modules = [ ./hosts/proxmox/uptime.nix ];
        };
      };
    };
}
