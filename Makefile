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
	sudo nixos-rebuild switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#thegram

boot-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild boot --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#thegram

dry-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild dry-build --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#thegram

test-noupdate:
	@echo "NixOS: Building Nix Configuration"
	sudo nixos-rebuild test --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#thegram

update-difference:
	@/etc/scripts/nix-diff.sh

fresh-install:
	sudo nix run 'github:nix-community/disko/latest#disko-install' -- --flake /home/ayushmaan/.dotfiles/system\#thegram --disk root /dev/nvme0n1

# --------------------
#  Secondary System Commands
# --------------------
flatpak:
	@echo "Updating flatpaks"
	flatpak update --noninteractive --assumeyes

# --------------------
# Primary Container Commands
# --------------------
all-server: backup uptime adguard nextcloud changedetection mealie ntfy immich jellyfin glance paperless

remote-build = nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#$$system --target-host nixadmin@$$system

immich:
	@echo "----------------------------------------"
	@echo "Update: immich"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#immich --target-host nixadmin@immich; \

adguard:
	@echo "----------------------------------------"
	@echo "Update: adguard"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#adguard --target-host nixadmin@adguard; \

nextcloud:
	@echo "----------------------------------------"
	@echo "Update: nextcloud"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#nextcloud --target-host nixadmin@nextcloud; \

uptime:
	@echo "----------------------------------------"
	@echo "Update: uptime"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#uptime --target-host nixadmin@uptime; \

changedetection:
	@echo "----------------------------------------"
	@echo "Update: changedetection"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#changedetection --target-host nixadmin@changedetection; \

mealie:
	@echo "----------------------------------------"
	@echo "Update: mealie"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#mealie --target-host nixadmin@mealie; \

backup:
	@echo "----------------------------------------"
	@echo "Update: backup"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#backup --target-host nixadmin@backup; \

grafana:
	@echo "----------------------------------------"
	@echo "Update: grafana"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#grafana --target-host nixadmin@grafana; \

ntfy:
	@echo "----------------------------------------"
	@echo "Update: ntfy"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#ntfy --target-host nixadmin@ntfy; \

jellyfin:
	@echo "----------------------------------------"
	@echo "Update: jellyfin"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#jellyfin --target-host nixadmin@jellyfin; \

glance:
	@echo "----------------------------------------"
	@echo "Update: glance"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#glance --target-host nixadmin@glance; \

ollama:
	@echo "----------------------------------------"
	@echo "Update: ollama"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#ollama --target-host nixadmin@ollama; \

paperless:
	@echo "----------------------------------------"
	@echo "Update: paperless"
	@dunstify "Waiting for authentication"
	nixos-rebuild --sudo switch --log-format=bar --flake /home/ayushmaan/.dotfiles/system\#paperless --target-host nixadmin@paperless; \
