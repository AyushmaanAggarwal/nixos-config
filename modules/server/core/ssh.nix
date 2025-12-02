{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    ssh.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables SSH Server";
      default = true;
    };
  };

  config = lib.mkIf (config.ssh.enable) {
    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
