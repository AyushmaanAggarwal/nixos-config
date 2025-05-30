{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    #home-manager.url = "github:nix-community/home-manager/master";
    home-manager.url = "github:AyushmaanAggarwal/home-manager/numbat_init_option";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    self,
    nixpkgs-unstable,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    formatter.${system} = nixpkgs-unstable.legacyPackages.${system}.alejandra;
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # Primary System
      thegram = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/thegram/configuration.nix];
      };

      # Server Containers
      backup = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/backup.nix];
      };

      etebase = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/etebase.nix];
      };

      adguard = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/adguard.nix];
      };

      immich = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/immich.nix];
      };

      nextcloud = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/nextcloud.nix];
      };

      uptime = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/uptime.nix];
      };

      changedetection = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/changedetection.nix];
      };

      ntfy = nixpkgs-stable.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/proxmox/ntfy.nix];
      };
    };
  };
}
