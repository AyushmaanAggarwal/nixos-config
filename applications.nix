# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by 
# running ‘nixos-help’).

{ config, pkgs, ... }:

{ 
  # Enable networking
  networking.networkmanager.enable = true;

  # services.xserver = {
  # 	# Enable the X11 windowing system.
  #       enable = false;
  #       
  #       # Enable the GNOME Desktop Environment.
  #       displayManager.gdm.enable = true; 
  #       desktopManager.gnome.enable = false;
  #       
  #       # Configure keymap in X11
  #       xkb.layout = "us"; 
  #       xkb.variant = "";

  # 	# Enable touchpad support (enabled default in most desktopManager). services.xserver.libinput.enable = true;
  # };
	
  
  services.printing.enable = true; # Enable CUPS to print documents.
  services.tailscale.enable = true; 
  services.blueman.enable = true;
  services.flatpak.enable = true; 

  security.polkit.enable = true;

  hardware.bluetooth = {
	enable = true;
	powerOnBoot = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false; 
  security.rtkit.enable = true; 
  services.pipewire = {
    enable = true; 
    pulse.enable = true;
    alsa.enable = true; 
    alsa.support32Bit = true; 
    # If you want to use JACK applications, uncomment this jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ayushmaan = { 
    isNormalUser = true; description = "Ayushmaan Aggarwal"; 
    extraGroups = [ "networkmanager" "wheel" ]; 
    packages = with pkgs; [
	# System Applications
	hyprlock
	hyprpaper
      	waybar

	# GUI Applications
	thunderbird
      	kitty
	fuzzel
      	calibre
      	inkscape
	syncthing
	distrobox
	virtualbox
	jetbrains-mono
	signal-desktop
	bitwarden-desktop
	slack
	spotify
	vlc
	gnome.nautilus

      
	# Terminal Applications
      	neovim
	fd
	tlp
	htop
	powertop
	rsync
	rclone
	fastfetch
	onefetch
	unzip
	grim
	slurp
	wl-clipboard
    ];
  };

  # Install progams
  programs = {
	firefox.enable = true;
	hyprland.enable = true;
	zsh.enable = true;
	steam.enable=true;
  };

  virtualisation = {
    containers.enable = true;
    podman.enable=true;

  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [ 
    vim
    git
    gcc
    wget
  ];



}

