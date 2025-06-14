{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:Mic92/sops-nix";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs-unstable,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    helper = import ./lib { inherit inputs outputs; };
  in {
    formatter = helper.forAllSystems (system: nixpkgs-unstable.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # Primary System
      thegram = helper.mkDesktop {
        hostname = "thegram";
        desktop = "hyprland";
      };

      # Server Containers
      adguard = helper.mkServerLXC {
        hostname = "adguard";
      };

      backup = helper.mkServerLXC {
        hostname = "backup";
      };

      etebase = helper.mkServerLXC {
        hostname = "etebase";
      };

      immich = helper.mkServerLXC {
        hostname = "immich";
      };

      nextcloud = helper.mkServerLXC {
        hostname = "nextcloud";
      };

      uptime = helper.mkServerLXC {
        hostname = "uptime";
      };

      changedetection = helper.mkServerLXC {
        hostname = "changedetection";
      };

      ntfy = helper.mkServerLXC {
        hostname = "ntfy";
      };

      mealie = helper.mkServerLXC {
        hostname = "mealie";
      };

    };

    githubActions = inputs.nix-github-actions.lib.mkGithubMatrix { checks = self.packages; };
    packages.x86_64-linux.thegram = nixpkgs-unstable.legacyPackages.x86_64-linux.thegram;
    packages.x86_64-linux.backup = nixpkgs-stable.legacyPackages.x86_64-linux.backup;
    checks.x86_64-linux.thegram = nixpkgs-unstable.legacyPackages.x86_64-linux.thegram;
    checks.x86_64-linux.backup = nixpkgs-stable.legacyPackages.x86_64-linux.thegram;
  };
}
