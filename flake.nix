{
  description = "NixOS Configuration";

  inputs = {
    # General Inputs
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    sops-nix.url = "github:Mic92/sops-nix";

    # Desktop Inputs
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim-config.url = "github:AyushmaanAggarwal/nixvim-config";

    # DNS Crypt
    dnscrypt-stevenblack = {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      flake = false;
    };
    dnscrypt-oisd = {
      url = "https://big.oisd.nl/domainswild";
      flake = false;
    };
    # dnscrypt-hagezi = {
    #   url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro-onlydomains.txt";
    #   flake = false;
    # };
    #dnscrypt-hagezi-tif = {
    #  url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/tif-onlydomains.txt";
    #  flake = false;
    #};

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
          filesystem = "zfs";
          hostID = "4303477a"; # generate using "head -c4 /dev/urandom | od -A none -t x4"
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

        paperless = helper.mkServerLXC { hostname = "paperless"; };

        linkwarden = helper.mkServerLXC { hostname = "linkwarden"; };

        searxng = helper.mkServerLXC { hostname = "searxng"; };
      };
    };
}
