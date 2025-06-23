# --------------------
# General Make Commands
# --------------------
update:
	nix flake update --commit-lock-file

pull:
	git pull origin master

all: update switch all-server


# --------------------
#  Primary System Commands
# --------------------
switch: pull noupdate-switch update-difference

boot: pull noupdate-boot update-difference

test: pull noupdate-test update-difference

noupdate-switch:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild switch --upgrade --flake /home/ayushmaan/.dotfiles/system\#thegram

noupdate-boot: update
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild boot --upgrade --flake /home/ayushmaan/.dotfiles/system\#thegram

noupdate-test:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild test --upgrade --flake /home/ayushmaan/.dotfiles/system\#thegram

update-difference:
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
	@echo; echo "Changed Packages Overall Size:"
	@/etc/scripts/nix-diff.py | grep -oE "[\+\-][0-9]+\.[0-9]\s[a-zA-Z]+" | tr '\n' ' ' | awk 'END{print $0 "+ 0GB to GB"}' | numbat
	@echo
	@/etc/scripts/nix-diff.py

# --------------------
# Primary Container Commands
# --------------------
all-server: backup uptime adguard nextcloud changedetection mealie ntfy grafana immich 

remote-build = nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

immich:
	@system="immich"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

adguard:
	@system="adguard"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

nextcloud:
	@system="nextcloud"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

uptime:
	@system="uptime"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

changedetection:
	@system="changedetection"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

mealie:
	@system="mealie"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

backup:
	@system="backup"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

grafana:
	@system="grafana"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

ntfy:
	@system="ntfy"
	@echo "Update: $$system"
	@nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system
