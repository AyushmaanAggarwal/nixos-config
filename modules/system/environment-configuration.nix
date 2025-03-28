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
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin
      echo "--------------------"
      echo "NixOs Update"
      echo "--------------------"
      pushd /home/ayushmaan/.dotfiles/system/ > /dev/null
      nix flake update --commit-lock-file
      if [[ -n $(git status --porcelain) ]]; then 
        echo "NixOS: Testing Nix Configuration - To permantely apply changes, commit all files in nix config"
        sudo nixos-rebuild test --flake /home/ayushmaan/.dotfiles/system/
      else
        echo "NixOS: Building Nix Configuration"
        sudo nixos-rebuild switch --upgrade --flake /home/ayushmaan/.dotfiles/system/
        
        echo "Changed Packages"
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
        /etc/scripts/nix-diff.py
      fi
      popd > /dev/null

      echo "--------------------"
      echo "Flatpak Update"
      echo "--------------------"
      flatpak update

      echo "--------------------"
      echo "Conda Update"
      echo "--------------------"
      conda-shell -c "conda update conda --yes"

      # echo "--------------------"
      # echo "NPM Update"
      # echo "--------------------"
      # npm install -g npm@latest
      # npm update
      '';
      mode = "0755";
    };
    "scripts/nix-server-update.sh" = {
      text = ''
      #!/bin/sh
      echo "--------------------"
      echo "NixOs Etebase Server Update"
      echo "--------------------"
      pushd /home/ayushmaan/.dotfiles/server-system/ > /dev/null
      nix flake update --commit-lock-file
      nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/server-system#nixos-etebase --target-host proxmox@etebase --use-remote-sudo
      popd > /dev/null
      '';
      mode = "0755";
    };
 
 
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { 
    LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8"; 
    LC_MEASUREMENT = "en_US.UTF-8"; 
    LC_MONETARY = "en_US.UTF-8"; 
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8"; 
    LC_PAPER = "en_US.UTF-8"; 
    LC_TELEPHONE = "en_US.UTF-8"; 
    LC_TIME = "en_US.UTF-8";
  };

}
