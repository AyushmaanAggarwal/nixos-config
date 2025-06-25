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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = ["nixadmin"];
    cores = 3;
    max-jobs = 4;
  };

  # Automatic updates
  system.autoUpgrade = {
    enable = true;
    flake = "github:AyushmaanAggarwal/nixos-config#${hostname}";
    dates = "hourly";
    randomizedDelaySec = "10min";
    allowReboot = true;
    flags = [
      "--build-host"
      "proxmox@backup"
      "--option"
      "tarball-ttl"
      "0"
    ];
  };

  systemd.services.reboot = {
    enable = true;
    after = ["nixos-upgrade.service"];
    description = "Restic Backup System";
    serviceConfig = {
      User = "root";
      ExecStart = ''reboot'';
    };
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
