# Backup Services
{ config, pkgs, ... }:
{
  # --- Syncthing ---
  services.syncthing = {
    enable = true;
    user = "ayushmaan";
    # Default folder for new synced folders
    dataDir = "/home/ayushmaan/Documents";
    # Folder for Syncthing's settings and keys
    configDir = "/home/ayushmaan/.local/state/syncthing";#.config/syncthing";
  };

  # --- Restic ---
  users.users.ayushmaan.packages = with pkgs; [
      restic
  ];

  users.users.restic = {
    isNormalUser = true;
  };
  
  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  # Required etc files
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
      /home/ayushmaan/.config/
      /home/ayushmaan/Zotero/
      /home/ayushmaan/Documents/
      /home/ayushmaan/Pictures/
      '';
      mode = "0644";
    };
    "restic/exclude_files" = {
      text = ''
      '';
      mode = "0644";
    };

    "scripts/backup.sh" = {
      text = ''
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

      source /home/ayushmaan/.bws/secret.sh
      export RCLONE_CONFIG_PASS=$(bws secret get 197ce53f-f34a-4ae0-8362-b1a0006600b5 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_PASSWORD=$(bws secret get fd396c44-c98a-4ef6-8522-b1ec00198028 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_REPOSITORY_FILE=/etc/restic/repo
      export $(dbus-launch)
      
      echo; echo "Backing up files"
      #dunstify "Backup" "Starting System Backup" --timeout=60000 || echo "Couldn't notify user"
      nice -n 19 restic backup --verbose --skip-if-unchanged --files-from=/etc/restic/include_files --exclude-file=/etc/restic/exclude_files
      exit_code_backup=$?

      echo; echo "Cleaning up backups"
      nice -n 19 restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 3 --keep-yearly 2
      exit_code_prune=$?

      pushd /home/ayushmaan/.dotfiles/scripts/python/ > /dev/null
      source venv/bin/activate
      python3 slack_notification.py "Finished restic backup for $(date +'%D %T'): Error Code Backup $exit_code_backup, Error Code Prune $exit_code_prune"
      popd > /dev/null
      '';
      mode = "0755";
    };
    "scripts/restic.sh" = {
      text = ''
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

      source /home/ayushmaan/.bws/secret.sh
      export RCLONE_CONFIG_PASS=$(bws secret get 197ce53f-f34a-4ae0-8362-b1a0006600b5 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_PASSWORD=$(bws secret get fd396c44-c98a-4ef6-8522-b1ec00198028 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_REPOSITORY_FILE=/etc/restic/repo
      
      restic snapshots
      restic check --read-data-subset=5%
      '';
      mode = "0755";
    };
  };
}
