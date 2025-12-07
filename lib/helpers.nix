{
  inputs,
  outputs,
  ...
}:
let
  lib = inputs.nixpkgs-unstable.lib;
  lib-stable = inputs.nixpkgs-stable.lib;
  functions = import ./nix-functions.nix { inherit inputs outputs lib; };
in
{
  mkDesktop =
    {
      hostname,
      username ? "ayushmaan",
      desktop,
      platform ? "x86_64-linux",
      hostID,
      filesystem ? "btrfs",
    }:
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          functions
          hostname
          username
          desktop
          platform
          hostID
          filesystem
          ;
      };
      modules = [
        ../hosts/${hostname}/configuration.nix
        ../home-manager
      ];
    };

  mkDisko =
    {
      hostname,
      platform ? "x86_64-linux",
      hostID,
    }:
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          hostID
          ;
      };

      modules = [
        ../hosts/${hostname}/disko.nix
      ];
    };

  mkServerLXC =
    {
      hostname,
      username ? "proxmox",
      desktop ? null,
      platform ? "x86_64-linux",
      domain-name ? "tail590ac.ts.net",
    }:
    let
      isTailscaleExitNode = hostname == "adguard";
      sshWithoutYubikey = hostname == "backup";
    in
    lib-stable.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          functions
          hostname
          username
          desktop
          platform
          domain-name
          isTailscaleExitNode
          sshWithoutYubikey
          ;
      };
      modules = [ ../hosts/proxmox/configuration.nix ];
    };

  forAllSystems = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
