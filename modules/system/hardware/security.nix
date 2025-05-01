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
    ACTION=="remove", ENV{ID_VENDOR}=="Yubico", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0402", RUN+="${pkgs.hyprlock}/bin/hyprlock -c /home/ayushmaan/.dotfiles/config/hypr/hyprlock.conf"
  '';

}

