# Backup Services
{
  config,
  pkgs,
  ...
}:
let
  secrets-file = ../../../../secrets/thegram/backups.yaml;
in
{
  sops.secrets.configuration = {
    owner = "ayushmaan";
    group = "users";
    mode = "0400";
    sopsFile = secrets-file;
  };

  sops.secrets.encryption = {
    owner = "ayushmaan";
    group = "users";
    mode = "0400";
    sopsFile = secrets-file;
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


        if [ "$exit_code_backup" -eq 0 ] && [ "$exit_code_prune" -eq 0 ]; then
            message="Successful Backup on $date"
        elif [ "$exit_code_backup" -eq 0 ]; then
            message="Failed Prune on $date:\nPrune Error: $exit_code_prune"
        elif [ "$exit_code_prune" -eq 0 ]; then
            message="Failed Backup on $date:\nBackup Error: $exit_code_backup"
        else
            message="Failed Backup and Prune on $date:\nBackup Error: $exit_code_backup\nPrune Error: $exit_code_prune"
        fi

        if [ "$exit_code_backup" -eq 0 ] && [ "$exit_code_prune" -eq 0 ]; then
            priority="low"
        else
            priority="high"
        fi

        ntfy publish --title="thegram backup to gdrive" --priority=$priority thegram $message
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

        if [ "$exit_code_backup" -eq 0 ] && [ "$exit_code_prune" -eq 0 ]; then
            message="Successful Backup on $date"
        elif [ "$exit_code_backup" -eq 0 ]; then
            message="Failed Prune on $date:\nPrune Error: $exit_code_prune"
        elif [ "$exit_code_prune" -eq 0 ]; then
            message="Failed Backup on $date:\nBackup Error: $exit_code_backup"
        else
            message="Failed Backup and Prune on $date:\nBackup Error: $exit_code_backup\nPrune Error: $exit_code_prune"
        fi

        if [ "$exit_code_backup" -eq 0 ] && [ "$exit_code_prune" -eq 0 ]; then
            priority="low"
        else
            priority="high"
        fi

        ntfy publish --title="thegram backup to gdrive" --priority=$priority thegram $message
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

        title, date, exit_code_backup, exit_code_prune = sys.argv[-3:]
        if exit_code_backup == "0" and exit_code_prune == "0":
          message = f"Successful Backup on {date}"
        elif exit_code_backup == "0":
          message = f"Failed Prune on {date}:\nPrune Error: {exit_code_prune}"
        elif exit_code_prune == "0":
          message = f"Failed Backup on {date}:\nBackup Error: {exit_code_backup}"
        else:
          message = f"Failed Backup and Prune on {date}:\n Backup Error: {exit_code_backup}\n Prune Error: {exit_code_prune}"

        priority = '1' if exit_code_backup == "0" and exit_code_prune == "0" else '3'

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
