{
  inputs,
  outputs,
  ...
}: let
  helpers = import ./nixosSystem-helpers.nix { inherit inputs outputs; };
in {
  inherit (helpers)
    mkDesktop
    mkServerLXC
    forAllSystems
    ;
}
