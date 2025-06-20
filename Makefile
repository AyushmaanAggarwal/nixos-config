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

immich:
	system="immich"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

adguard:
	system="adguard"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

nextcloud:
	system="nextcloud"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

uptime:
	system="uptime"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

changedetection:
	system="changedetection"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

mealie:
	system="mealie"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

backup:
	system="backup"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \

grafana:
	system="grafana"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \



ntfy:
	system="ntfy"; \
	nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system --use-remote-sudo; \
