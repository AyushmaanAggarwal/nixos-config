{ config, pkgs, ... }:
{
  # Normal Security
  security.polkit.enable = true;

  # Add Yubikey Support
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.udev.extraRules = ''
      ACTION=="remove",\
       ENV{ID_VENDOR_FROM_DATABASE}=="Yubico.com",\
       ENV{ID_FIDO_TOKEN}=="1",\
       ENV{ID_SECURITY_TOKEN}=="1",\
       RUN+="${pkgs.hyprlock}/bin/hyprlock -c /home/ayushmaan/.dotfiles/config/hypr/hyprlock.conf"
  '';

}

