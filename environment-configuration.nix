{ config, pkgs, ... }:

{ 
  environment.etc = {
    "restic/repo" = {
      text = ''
      rclone:EncryptedDrive:NixOS/restic-backup
      '';
      mode = "0644";
    }; "restic/include_files" = {
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

    "scripts/backup.sh" = {
      text = ''
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

      source /home/ayushmaan/.bws/secret.sh
      export RCLONE_CONFIG_PASS=$(bws get secret 197ce53f-f34a-4ae0-8362-b1a0006600b5 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_PASSWORD=$(bws get secret fd396c44-c98a-4ef6-8522-b1ec00198028 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_REPOSITORY_FILE=/etc/restic/repo
      export $(dbus-launch)
      
      echo; echo "Backing up files"
      #dunstify "Backup" "Starting System Backup" --timeout=60000 || echo "Couldn't notify user"
      nice -n 19 restic backup --verbose --skip-if-unchanged --files-from=/etc/restic/include_files --exclude-file=/etc/restic/exclude_files

      echo; echo "Cleaning up backups"
      nice -n 19 restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 3 --keep-yearly 2

      #dunstify "Backup" "Finished System Backup" --timeout=60000 || echo "Couldn't notify user"
      kdeconnect-cli -d 977b80df_ab28_49bb_be25_d032af1d69ff --ping-msg "Finished restic backup for $(date +'%D %T')"|| echo "Couldn't ping phone"
      '';
      mode = "0755";
    };
    "scripts/restic.sh" = {
      text = ''
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

      source /home/ayushmaan/.bws/secret.sh
      export RCLONE_CONFIG_PASS=$(bws get secret 197ce53f-f34a-4ae0-8362-b1a0006600b5 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_PASSWORD=$(bws get secret fd396c44-c98a-4ef6-8522-b1ec00198028 | python -c "import sys, json; print(json.load(sys.stdin)['value'])")
      export RESTIC_REPOSITORY_FILE=/etc/restic/repo
      
      restic "$@"
      '';
      mode = "0755";
    };
    "scripts/nix-diff.py" = {
      text = ''
      #!/etc/profiles/per-user/ayushmaan/bin/python3
      import subprocess
      
      old_generation = None
      new_generation = None
      with open("/home/ayushmaan/.local/custom-files/nix-generations.txt") as f:
          for line in f.readlines():
              old_generation = new_generation
              new_generation, *_ = line.split(maxsplit=1)
      
      old = int(old_generation)
      new = int(new_generation)
      command = f"nix store diff-closures /nix/var/nix/profiles/system-{old}-link /nix/var/nix/profiles/system-{new}-link"
      result = subprocess.run(command.split(), capture_output=True, text=True)
      
      with open("/home/ayushmaan/.local/custom-files/nix-version-diff.txt", "w") as f:
          f.write(result.stdout)
      
      print(f"Difference between generation {old} and {new}")
      print(result.stdout)
      '';
      mode = "0755";
    };
    "scripts/nix-update.sh" = {
      text = ''
      !/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin

      sudo nixos-rebuild switch --upgrade
      sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
      /etc/scripts/nix-diff.py
      '';
      mode = "0755";
    };
 
  };
}
