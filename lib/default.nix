{ inputs, outputs, lib, ... }:
{
  mkDesktop =
    {
      hostname,
      username ? "ayushmaan",
      desktop,
      system ? "x86_64-linux",
    }:
    inputs.nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          hostname
          system
          username
          ;
      };
      modules = 
        [] 
        ++ lib.optional (builtins.pathExists (./.. + "/hosts/${hostname}/configuration.nix")) ./${hostname}/configuration.nix;
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
    inputs.nixpkgs-stable.lib.nixosSystem {
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
      modules = [../hosts/proxmox/proxmox.nix];
    };
  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
