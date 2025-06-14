{
  inputs,
  outputs,
  config,
  pkgs,
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
