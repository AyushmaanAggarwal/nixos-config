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
}
