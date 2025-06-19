# --------------------
# General Make Commands
# --------------------
update:
	nix flake update --commit-lock-file

all: update switch all-server

# --------------------
#  Primary System Commands
# --------------------
switch: update noupdate-switch update-difference

boot: update noupdate-boot update-difference

test: update noupdate-test update-difference

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

remote-build = nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --sudo

immich:
	@system="immich"
	@echo "Update: $$system"
	@$(remote-build)

adguard:
	@system="adguard"
	@echo "Update: $$system"
	@$(remote-build)

nextcloud:
	@system="nextcloud"
	@echo "Update: $$system"
	@$(remote-build)

uptime:
	@system="uptime"
	@echo "Update: $$system"
	@$(remote-build)

changedetection:
	@system="changedetection"
	@echo "Update: $$system"
	@$(remote-build)

mealie:
	@system="mealie"
	@echo "Update: $$system"
	@$(remote-build)

backup:
	@system="backup"
	@echo "Update: $$system"
	@$(remote-build)

grafana:
	@system="grafana"
	@echo "Update: $$system"
	@$(remote-build)

ntfy:
	@system="ntfy"
	@echo "Update: $$system"
	@$(remote-build)
