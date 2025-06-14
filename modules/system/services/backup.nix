# Backup Services
{
  config,
  pkgs,
  ...
}: {
  # --- Syncthing ---
  services.syncthing = {
    enable = true;
    user = "ayushmaan";
    # Default folder for new synced folders
    dataDir = "/home/ayushmaan/Documents";
    # Folder for Syncthing's settings and keys
    configDir = "/home/ayushmaan/.local/state/syncthing"; # .config/syncthing";
  };

  # --- Restic ---

  sops.secrets.configuration = {
    owner = "ayushmaan";
    group = "users";
    mode = "0400";
    sopsFile = ../../../secrets/thegram/backups.yaml;
  };

  sops.secrets.encryption = {
    owner = "ayushmaan";
    group = "users";
    mode = "0400";
    sopsFile = ../../../secrets/thegram/backups.yaml;
  };

  users.users.ayushmaan.packages = with pkgs; [
    restic
    python3Full
    python313Packages.requests
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
      user = "root";
      group = "root";
      mode = "0644";
    };
    "restic/backup_server" = {
      text = ''
        rclone:EncryptedProxmoxBackupServer:thegram/restic-server
      '';
      user = "root";
      group = "root";
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
      user = "root";
      group = "root";
      mode = "0644";
    };
    "restic/exclude_files" = {
      text = '''';
      user = "root";
      group = "root";
      mode = "0644";
    };

    "scripts/backup.sh" = {
      text = ''
        #!/bin/sh
        export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

        export RCLONE_CONFIG_PASS=$(/run/current-system/sw/bin/cat ${config.sops.secrets.configuration.path})
        export RESTIC_PASSWORD=$(/run/current-system/sw/bin/cat ${config.sops.secrets.encryption.path})
        export RESTIC_REPOSITORY_FILE=/etc/restic/repo

        echo; echo "Backing up files"
        nice -n 19 restic backup --verbose --skip-if-unchanged --files-from=/etc/restic/include_files --exclude-file=/etc/restic/exclude_files
        exit_code_backup=$?

        echo; echo "Cleaning up backups"
        nice -n 19 restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 3 --keep-yearly 2
        exit_code_prune=$?

        python3 /etc/scripts/restic-notify.py "thegram to Google Drive" $(date +'%D %T') $exit_code_backup $exit_code_prune
      '';
      user = "root";
      group = "root";
      mode = "0755";
    };
    "scripts/backup-to-server.sh" = {
      text = ''
        #!/bin/sh
        export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

        export RCLONE_CONFIG_PASS=$(/run/current-system/sw/bin/cat ${config.sops.secrets.configuration.path})
        export RESTIC_PASSWORD=$(/run/current-system/sw/bin/cat ${config.sops.secrets.encryption.path})
        export RESTIC_REPOSITORY_FILE=/etc/restic/backup_server

        echo; echo "Backing up files"
        nice -n 19 restic backup --verbose --skip-if-unchanged --files-from=/etc/restic/include_files --exclude-file=/etc/restic/exclude_files
        exit_code_backup=$?

        echo; echo "Cleaning up backups"
        nice -n 19 restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 3 --keep-yearly 2
        exit_code_prune=$?

        python3 /etc/scripts/restic-notify.py "thegram to server" $(date +'%D %T') $exit_code_backup $exit_code_prune
      '';
      user = "root";
      group = "root";
      mode = "0755";
    };

    "scripts/restic.sh" = {
      text = ''
        #!/bin/sh

        export RCLONE_CONFIG_PASS=$(/run/current-system/sw/bin/cat ${config.sops.secrets.configuration.path})
        export RESTIC_PASSWORD=$(/run/current-system/sw/bin/cat ${config.sops.secrets.encryption.path})
        export RESTIC_REPOSITORY_FILE=/etc/restic/repo

        restic snapshots
        restic check --read-data-subset=5%
      '';
      user = "root";
      group = "root";
      mode = "0755";
    };

    "scripts/restic-notify.py" = {
      text = ''
        import sys
        import requests

        title, date, backup_err, check_err = sys.argv[-3:]
        if backup_err == "0" and check_err == "0":
          message = f"Successful Backup on {date}"
        elif backup_err == "0":
          message = f"Failed Prune on {date}:\nPrune Error: {check_err}"
        elif check_err == "0":
          message = f"Failed Backup on {date}:\nBackup Error: {backup_err}"
        else:
          message = f"Failed Backup and Prune on {date}:\n Backup Error: {backup_err}\n Prune Error: {check_err}"

        priority = '1' if backup_err == "0" and check_err == "0" else '3'

        requests.post("https://ntfy.tail590ac.ts.net/thegram",
          data=message,
          headers={
          'Title': f'Restic Backup: {title}',
          'Priority': priority,
        })
      '';
      user = "root";
      group = "root";
      mode = "0755";
    };
  };
}
