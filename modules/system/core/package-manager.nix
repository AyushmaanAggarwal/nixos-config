{ inputs, config, pkgs, ... }:
{

  services.flatpak.enable = true; 

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://hyprland.cachix.org"
      "https://cache.nixos.org/"
    ];

    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];

    max-jobs = 4;
    cores = 3;
  };
 
  # Automatically update system
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "-L" # print build logs
    ];
    persistent = true;
    dates = "02:00";
  };
  systemd.services.nixos-upgrade = {
    after = ["chronyd.service"];
  };
 
  # Label Generations
  system.nixos.label = (builtins.concatStringsSep "-" (builtins.sort (x: y: x < y) config.system.nixos.tags)) + config.system.nixos.version + "-SHA:${inputs.self.shortRev}";

  # Collect garbage
  nix.gc = {
    automatic = true;
    dates = "03:00";
    options = "--delete-older-than 30d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };


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
      flatpak update --assumeyes --noninteractive
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
 
}
