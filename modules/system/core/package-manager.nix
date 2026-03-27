{
  inputs,
  config,
  pkgs,
  ...
}:
{
  services.flatpak.enable = true;

  # Enable Flakes
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Automatically update system
  system.autoUpgrade = {
    enable = false;
    flake = inputs.self.outPath;
    flags = [
      "-L" # print build logs
    ];
    persistent = true;
    dates = "02:00";
  };
  systemd.services.nixos-upgrade = {
    #after = [ "chronyd.service" ];
  };

  # Label Generations
  system.nixos.label =
    (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags))
    + config.system.nixos.version
    + "-SHA:${inputs.self.shortRev or "dirty"}";

  # Collect garbage
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    randomizedDelaySec = "30min";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
    persistent = true;
    randomizedDelaySec = "30min";
    dates = "weekly";
  };
}
