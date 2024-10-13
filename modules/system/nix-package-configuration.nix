{ inputs, config, pkgs, ... }:
{
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatically update system
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "02:00";
  };

  # Label Generations
  system.nixos.label = (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags)) + config.system.nixos.version + "-SHA:${inputs.self.shortRev}";

  # Collect garbage
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 30d";
  };
}
