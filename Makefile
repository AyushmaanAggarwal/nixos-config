update:
	nix flake update --commit-lock-file

switch: update
	echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild switch --upgrade --flake /home/ayushmaan/.dotfiles/system\#thegram
	echo "Changed Packages"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
	/etc/scripts/nix-diff.py

boot: update
	echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild boot --upgrade --flake /home/ayushmaan/.dotfiles/system\#thegram
	echo "Changed Packages"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
	/etc/scripts/nix-diff.py

test: update
	echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild test --upgrade --flake /home/ayushmaan/.dotfiles/system\#thegram
	echo "Changed Packages"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
	/etc/scripts/nix-diff.py

build-server:
	read system
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$system --use-remote-sudo

update-server:
	systems=("immich" "adguard" "nextcloud" "uptime") #  "calibre" "backup" "etebase" 
	for system in "$${systems[@]}"; do
	  echo "Updating System: $${system}"; 
	  nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$system --use-remote-sudo
	done

all: update switch server
