{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
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
  };
}
