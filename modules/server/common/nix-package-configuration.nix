{ inputs, config, pkgs, ... }:
{
  # Enable Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "nixadmin" ];
  };
 
}
