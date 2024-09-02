# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by 
# running ‘nixos-help’).

{ config, pkgs, ... }:
{
  
  services.tailscale = {
    package = pkgs.unstable.tailscale;
    enable = true;
  };
    
  services.printing.enable = true; # Enable CUPS to print documents.
  services.blueman.enable = true;
  services.flatpak.enable = true; 
  services.syncthing = {
        enable = true;
        user = "ayushmaan";
        dataDir = "/home/ayushmaan/Documents";    # Default folder for new synced folders
        configDir = "/home/ayushmaan/.local/state/syncthing";#.config/syncthing";   # Folder for Syncthing's settings and keys
      
  };
  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;

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
        dunst

        # Gnome applications
        gnome.nautilus

        # GUI Applications
        unstable.thunderbird # fast moving project
        unstable.xournalpp # unstable contains missing icon fix
        kitty
        fuzzel
        calibre
        inkscape
        distrobox
        virtualbox
        jetbrains-mono
        signal-desktop
        bitwarden-desktop
        slack
        spotify
        vlc

      
        # Terminal Applications
        fd
        tlp
        bws
        unzip
        rsync
        rclone
        nodejs
        python3
        ## Notes
        unstable.neovim # fast moving project
        pandoc
        lua-language-server
        texliveFull
        ## Monitoring
        htop
        fastfetch
        onefetch
        powertop
        ## Screenshots
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

