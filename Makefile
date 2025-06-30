# --------------------
# General Make Commands
# --------------------
update:
	nix flake update --commit-lock-file

pull:
	git pull origin master

push:
	git push origin master

all: update switch all-server


# --------------------
#  Primary System Commands
# --------------------
switch: pull update push noupdate-dry noupdate-switch update-difference

boot: pull noupdate-boot update-difference

test: pull noupdate-test update-difference

noupdate-switch:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#thegram

noupdate-boot: update
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild boot --flake /home/ayushmaan/.dotfiles/system\#thegram

noupdate-dry: update
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild dry-build --flake /home/ayushmaan/.dotfiles/system\#thegram

noupdate-test:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild test --flake /home/ayushmaan/.dotfiles/system\#thegram

update-difference:
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system > /home/ayushmaan/.local/custom-files/nix-generations.txt
	@echo; echo "Changed Packages Overall Size:"
	@/etc/scripts/nix-diff.py | grep -oE "[\+\-][0-9]+\.[0-9]\s[a-zA-Z]+" | tr '\n' ' ' | awk 'END{print $0 "+ 0GB to GB"}' | numbat
	@echo
	@/etc/scripts/nix-diff.py

# --------------------
# Primary Container Commands
# --------------------
all-server: backup uptime adguard nextcloud changedetection mealie ntfy immich 

remote-build = nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

immich:
	@echo "Update: immich"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#immich --target-host nixadmin@immich; \

adguard:
	@echo "Update: adguard"; \
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#adguard --target-host nixadmin@adguard; \

nextcloud:
	@echo "Update: nextcloud"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#nextcloud --target-host nixadmin@nextcloud; \

uptime:
	@echo "Update: uptime"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#uptime --target-host nixadmin@uptime; \

changedetection:
	@echo "Update: changedetection"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#changedetection --target-host nixadmin@changedetection; \

mealie:
	@echo "Update: mealie"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#mealie --target-host nixadmin@mealie; \

backup:
	@echo "Update: backup"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#backup --target-host nixadmin@backup; \

grafana:
	@echo "Update: grafana"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#grafana --target-host nixadmin@grafana; \

ntfy:
	@echo "Update: ntfy"
	nixos-rebuild --use-remote-sudo switch --flake /home/ayushmaan/.dotfiles/system\#ntfy --target-host nixadmin@ntfy; \
