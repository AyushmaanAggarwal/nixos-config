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

        # Server Containers
        adguard = helper.mkServerLXC { hostname = "adguard"; };

        backup = helper.mkServerLXC { hostname = "backup"; };

        etebase = helper.mkServerLXC { hostname = "etebase"; };

        grafana = helper.mkServerLXC { hostname = "grafana"; };

        immich = helper.mkServerLXC { hostname = "immich"; };

        nextcloud = helper.mkServerLXC { hostname = "nextcloud"; };

        uptime = helper.mkServerLXC { hostname = "uptime"; };

        changedetection = helper.mkServerLXC { hostname = "changedetection"; };

        ntfy = helper.mkServerLXC { hostname = "ntfy"; };

        mealie = helper.mkServerLXC { hostname = "mealie"; };

        jellyfin = helper.mkServerLXC { hostname = "jellyfin"; };

        glance = helper.mkServerLXC { hostname = "glance"; };

        ollama = helper.mkServerLXC { hostname = "ollama"; };

        onlyoffice = helper.mkServerLXC { hostname = "onlyoffice"; };
      };
    };
}
