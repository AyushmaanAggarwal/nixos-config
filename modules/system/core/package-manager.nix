{ inputs, config, pkgs, ... }:
{

  services.flatpak.enable = true; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.nixos.org/"
    ];

    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];

    max-jobs = 4;
    cores = 3;
  };
 
  # Automatically update system
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "-L" # print build logs
    ];
    persistent = true;
    dates = "02:00";
  };
  systemd.services.nixos-upgrade = {
    after = ["chronyd.service"];
  };
 
  # Label Generations
  system.nixos.label = (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags)) + config.system.nixos.version + "-SHA:${inputs.self.shortRev}";

  # Collect garbage
  nix.gc = {
    automatic = true;
    dates = "03:00";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
 
}
