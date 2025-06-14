{
  inputs,
  outputs,
  config,
  pkgs,
  hostname,
  username,
  desktop,
  system,
  ...
}: {
  # Add unstable overlay for newer packages
  nixpkgs.overlays = [
    outputs.overlays.unstable-packages
  ];

  # Enable Flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["nixadmin"];
    cores = 3;
    max-jobs = 4;
  };

  # Automatic updates
  system.autoUpgrade = {
    enable = true;
    flake = "github:AyushmaanAggarwal/nixos-config#${hostname}";
    dates = "minutely";
    flags = [ "--option" "tarball-ttl" "0" ];
  };

  # Collect garbage
  nix.gc = {
    automatic = true;
    dates = "01:00";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };
}
