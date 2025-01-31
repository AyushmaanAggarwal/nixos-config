# Main Configuration
{ pkgs, ... }:

{ 
  imports =
    [ 
      # Hyprland activates ./polkit.nix
      #./btrfs-scrub.nix
      ./restic-backup.nix
    ];

}

