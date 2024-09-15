{ config, pkgs, ... }:

{ 
  environment.etc = {
    "restic/repo" = {
      text = ''
      rclone:EncryptedDrive:NixOS/restic-backup
      '';
      mode = "0644";
    };
    "restic/include_files" = {
      text = ''
      /home/ayushmaan/.dotfiles/
      /home/ayushmaan/Documents/Obsidian/
      /home/ayushmaan/Documents/College/
      /home/ayushmaan/Pictures/
      '';
      mode = "0644";
    };
    "restic/exclude_files" = {
      text = ''
      '';
      mode = "0644";
    };
 
  };
}
