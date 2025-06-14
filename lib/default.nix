{ inputs, outputs, ... }:
let
  lib = inputs.nixpkgs-unstable.lib;
  lib-stable = inputs.nixpkgs-stable.lib;
in
{
  mkDesktop =
    {
      hostname,
      username ? "ayushmaan",
      desktop,
      system ? "x86_64-linux",
    }:
    lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          hostname
          username
          desktop
          system
          ;
      };
      modules = [
        ../hosts/${hostname}/configuration.nix
        ../home-manager
      ];
    };
 
  mkServerLXC = 
    {
      hostname,
      username ? "proxmox",
      desktop ? null,
      system ? "x86_64-linux",
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
          hostname
          username
          desktop
          system
          isTailscaleExitNode
          sshWithoutYubikey
          ;
      };
      modules = [../hosts/proxmox/configuration.nix];
    };
  forAllSystems = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
