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
    ACTION=="bind", ENV{ID_VENDOR}=="Yubico", ENV{ID_VENDOR_ID}=="1050", ENV{ID_MODEL_ID}=="0402", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    ACTION=="remove", ENV{ID_VENDOR_FROM_DATABASE}=="Yubico.com", ENV{ID_FIDO_TOKEN}=="1", ENV{ID_SECURITY_TOKEN}=="1", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

}

