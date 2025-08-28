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
      system ? "x86_64-linux",
    }:
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          outputs
          functions
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
      buildingImage ? false,
    }:
    let
      isTailscaleExitNode = hostname == "adguard";
      sshWithoutYubikey = hostname == "backup";
    in
    lib-stable.nixosSystem (
      lib-stable.mkMerge [
        {
          inherit system;
          specialArgs = {
            inherit
              inputs
              outputs
              functions
              hostname
              username
              desktop
              system
              isTailscaleExitNode
              sshWithoutYubikey
              ;
          };
          modules = [ ../hosts/proxmox/configuration.nix ];
        }
        (lib-stable.mkIf (!buildingImage) {
          modules = [ ../hosts/proxmox/proxmox-lxc-image.nix ];
        })
      ]
    );

  forAllSystems = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
