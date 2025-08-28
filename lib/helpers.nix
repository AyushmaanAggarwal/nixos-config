{
  inputs,
  outputs,
  ...
}:
let
  lib = inputs.nixpkgs-unstable.lib;
  lib-stable = inputs.nixpkgs-stable.lib;
  functions = import ./nix-functions.nix { inherit inputs outputs lib; };

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
      lib.mkMerge [
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

  mkListOfDefaultLXC =
    hostList:
    (
      let
        # Simple function to build host with hostname
        mkLXC =
          buildImage: host:
          mkServerLXC {
            hostname = host;
            buildingImage = buildImage;
          };
        # Build Name is renamed from <host> to <host>-image for all build options
        mapBuildName = name: value: lib.attrsets.nameValuePair "${name}-image" value;
      in
      (lib-stable.genAttrs hostList (mkLXC false))
      // (lib.attrsets.mapAttrs' mapBuildName (lib-stable.genAttrs hostList (mkLXC true)))
    );

  forAllSystems = lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
