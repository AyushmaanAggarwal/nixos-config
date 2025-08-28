{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    nixvim-config.url = "github:AyushmaanAggarwal/nixvim-config";
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      helper = import ./lib { inherit inputs outputs; };
    in
    {
      formatter = helper.forAllSystems (
        system: nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style
      );
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        # Primary System
        thegram = helper.mkDesktop {
          hostname = "thegram";
          desktop = "hyprland";
        };

      }
      # Server Containers
      // (helper.mkListOfDefaultLXC [
        "adguard"
        "backup"
        "immich"
        "nextcloud"
        "uptime"
        "changedetection"
        "ntfy"
        "mealie"
        "jellyfin"
        "glance"
        "onlyoffice"
        # Not in production
        # "etebase"
        # "grafana"
        # "ollama"
      ]);
    };
}
