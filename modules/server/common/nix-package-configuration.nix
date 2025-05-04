{ inputs, config, pkgs, ... }:
{
  # Enable Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
 
  nix.settings.trusted-users = [ "nixadmin" ];

}
