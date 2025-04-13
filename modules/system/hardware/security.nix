{ config, pkgs, ... }:
{
  # Normal Security
  security.polkit.enable = true;

  # Fingerprint service
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
  services.fprintd.enable = true;
  # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  services.fprintd.tod = {
    enable = true;
    # driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
    driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver                    
    # driver = pkgs.libfprint-2-tod1-vfs0090; # driver for 2016 ThinkPads 
    # driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)  
  };
}

