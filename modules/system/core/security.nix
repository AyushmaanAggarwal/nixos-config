{ inputs, config, lib, pkgs, ... }:
{
  options = {
    yubikey.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Yubikey Configuration";
      default = true;
    };
  };
  config = lib.mkMerge [
    {
      # Normal Security
      security.polkit.enable = true;
    }
    (lib.mkIf config.yubikey.enable {
      # Add Yubikey Support
      security.pam.services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    
      services.udev.extraRules = ''
        ACTION=="remove", ENV{ID_VENDOR_FROM_DATABASE}=="Yubico.com", ENV{ID_FIDO_TOKEN}=="1", ENV{ID_SECURITY_TOKEN}=="1", RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    })
  ];
}

