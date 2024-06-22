# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by 
# running ‘nixos-help’).

{ config, pkgs, ... }:

{ 
  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver = {
  	# Enable the X11 windowing system.
	enable = false;
	
	# Enable the GNOME Desktop Environment.
	displayManager.gdm.enable = true; 
	desktopManager.gnome.enable = false;
	
	# Configure keymap in X11
	xkb.layout = "us"; 
        xkb.variant = "";

  	# Enable touchpad support (enabled default in most desktopManager). services.xserver.libinput.enable = true;
  };
	
  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  services.blueman.enable = true;
  hardware.bluetooth = {
	enable = true;
	powerOnBoot = true;
  };

  services.flatpak.enable = true; 
  security.polkit.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false; security.rtkit.enable = true; services.pipewire = {
    enable = true; alsa.enable = true; alsa.support32Bit = true; pulse.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ayushmaan = { 
    isNormalUser = true; description = "Ayushmaan Aggarwal"; 
    extraGroups = [ "networkmanager" "wheel" ]; 
    packages = with pkgs; [
	# GUI Applications
	thunderbird
      	neovim
      	kitty
      	swaybg
      	waybar
	fuzzel
      	calibre
      	inkscape
	steam
	podman
	syncthing
	distrobox
	virtualbox
	jetbrains-mono
	signal-desktop
	bitwarden-desktop
	slack
	spotify
	vlc
	hyprlock
	hyprpaper
	gnome.nautilus
	grim
	slurp
	wl-clipboard

      
	# Terminal Applications
	fd
	tlp
	powertop
	rsync
	rclone
	tailscale
	fastfetch
	onefetch
	
    ];
  };

  # Install progams
  programs = {
	firefox.enable = true;
	hyprland.enable = true;
	zsh.enable = true;
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [ 
    vim
    git
    gcc
    htop
    wget
  ];



}

