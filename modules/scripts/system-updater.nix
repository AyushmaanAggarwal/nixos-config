{ inputs, config, lib, pkgs, ... }:
{
  environment.etc = {
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
      echo "NixOS Update"
      echo "--------------------"
      pushd /home/ayushmaan/.dotfiles/system/ > /dev/null
      nix flake update --commit-lock-file
      if [[ -n $(git status --porcelain) ]]; then 
      	echo "Commit all changes before building"
	git status
	exit 0
      else
        echo "NixOS: Building Nix Configuration"
        sudo nixos-rebuild switch --upgrade --flake /home/ayushmaan/.dotfiles/system#thegram
        
        echo "Changed Packages"
        sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
        echo; echo "Changed Packages Overall Size:"
        /etc/scripts/nix-diff.py | grep -oE "[\+\-][0-9]+\.[0-9]\s[a-zA-Z]+" | tr '\n' ' ' | sed 's/$/ to GB/' | numbat
        echo; echo "Changed Packages Breakdown: "
        /etc/scripts/nix-diff.py
      fi
      popd > /dev/null

      echo "--------------------"
      echo "Flatpak Update"
      echo "--------------------"
      flatpak update --assumeyes --noninteractive

      echo "--------------------"
      echo "Update Containers"
      echo "--------------------"
      bash /etc/scripts/nix-server-update.sh --noupdate

      '';
      mode = "0755";
    };
    "scripts/nix-server-update.sh" = {
      text = ''
      #!/bin/bash
      
      # Parsing inputs
      TEMP=$(getopt -o sf: -l system,noupdate:)
      
      UPDATE_FLAKE=true
      REMOTE_SYSTEM="all"
      
      while true; do
        case "$1" in
          -f | --noupdate ) UPDATE_FLAKE=false; shift 1; continue;;
          -s | --system ) REMOTE_SYSTEM="$2"; shift 2; continue;;
          "") break;;
          * ) shift;;
        esac
      done
      
      # Updating lockfile
      if [ "$UPDATE_FLAKE" = true ]; then
        echo "Updating Flake"
        nix flake update --commit-lock-file
      fi
      
      if [ "$REMOTE_SYSTEM" = "all" ]; then
        systems=("immich" "adguard" "etebase" "nextcloud" "uptime") #  "calibre" "backup"
      else
        systems=( "$REMOTE_SYSTEM" )
      fi

      for system in "''${systems[@]}"; do
        echo "Updating System: ''${system}"; 
        nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system#$system --target-host nixadmin@$system --use-remote-sudo
      done
      '';
      mode = "0755";
    };

    "scripts/nix-server-generate.sh" = {
      text = ''
      #!/bin/bash
      
      echo "Create a container for:"
      echo "1) Backup"
      echo "2) Etebase"
      echo "3) Adguard"
      echo "4) Immich"
      echo "5) Nextcloud"
      echo "6) Calibre"
      echo "7) Uptime"
      
      read -n1 -p "Enter number here: " number
      case $number in  
        1) name="backup" ;; 
        2) name="etebase" ;; 
        3) name="adguard" ;; 
        4) name="immich" ;; 
        5) name="nextcloud" ;; 
        6) name="calibre" ;; 
        7) name="uptime" ;; 
        *) echo dont know ;; 
      esac
      echo "Generating Proxmox-LXC Container for ''${name}"; echo
      nix run github:nix-community/nixos-generators -- --flake ~/.dotfiles/server-system/#''${name} --cores 4 -f proxmox-lxc -o ./output/''${name}.tar.xz
      
      echo; echo "SHA512 Checksum:"
      sha512sum ./output/''${name}.tar.xz/tarball/nixos-system-x86_64-linux.tar.xz
      '';
      mode = "0755";
    };

  };
}
