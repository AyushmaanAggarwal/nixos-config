# --------------------
# General Make Commands
# --------------------
update:
	nix flake update --commit-lock-file

pull:
	git pull origin master

push:
	git push origin master

all: switch flatpak 

fix:
	sudo nix-store --verify --check-contents --repair
# --------------------
#  Primary System Commands
# --------------------
switch: pull update push dry-noupdate switch-noupdate update-difference

switch-nopull: update dry-noupdate switch-noupdate update-difference

boot: pull boot-noupdate update-difference

test: pull test-noupdate update-difference

switch-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild switch --flake /home/ayushmaan/.dotfiles/system\#thegram

boot-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild boot --flake /home/ayushmaan/.dotfiles/system\#thegram

dry-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild dry-build --flake /home/ayushmaan/.dotfiles/system\#thegram

test-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild test --flake /home/ayushmaan/.dotfiles/system\#thegram

update-difference:
	@/etc/scripts/nix-diff.sh

# --------------------
#  Secondary System Commands
# --------------------
flatpak:
	@echo "Updating flatpaks"
	flatpak update --noninteractive --assumeyes

# --------------------
# Primary Container Commands
# --------------------
all-server: backup uptime adguard nextcloud changedetection mealie ntfy immich jellyfin glance

remote-build = nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

immich:
	@echo "Update: immich" \
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#immich --target-host nixadmin@immich; \

adguard:
	@echo "Update: adguard"; \
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#adguard --target-host nixadmin@adguard; \

nextcloud:
	@echo "Update: nextcloud"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#nextcloud --target-host nixadmin@nextcloud; \

uptime:
	@echo "Update: uptime"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#uptime --target-host nixadmin@uptime; \

changedetection:
	@echo "Update: changedetection"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#changedetection --target-host nixadmin@changedetection; \

mealie:
	@echo "Update: mealie"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#mealie --target-host nixadmin@mealie; \

backup:
	@echo "Update: backup"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#backup --target-host nixadmin@backup; \

grafana:
	@echo "Update: grafana"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#grafana --target-host nixadmin@grafana; \

ntfy:
	@echo "Update: ntfy"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#ntfy --target-host nixadmin@ntfy; \

jellyfin:
	@echo "Update: jellyfin"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#jellyfin --target-host nixadmin@jellyfin; \

glance:
	@echo "Update: glance"
	nixos-rebuild --sudo switch --flake /home/ayushmaan/.dotfiles/system\#glance --target-host nixadmin@glance; \
