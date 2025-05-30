# Warning: Still in testing
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./caddy.nix
    ../common/sops-nix.nix
  ];
  options = {
    gitlab.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Adguard";
      default = false;
    };
  };

  config = lib.mkIf (config.adguard.enable) {
    sops.secrets = {
      gl-database-pass = {
        mode = "0400";
        sopsFile = ../../../secrets/gitlab/secrets.yaml;
      };
      gl-root-pass = {
        mode = "0400";
        sopsFile = ../../../secrets/gitlab/secrets.yaml;
      };
      gl-secret = {
        mode = "0400";
        sopsFile = ../../../secrets/gitlab/secrets.yaml;
      };
      gl-otp = {
        mode = "0400";
        sopsFile = ../../../secrets/gitlab/secrets.yaml;
      };
      gl-db-file = {
        mode = "0400";
        sopsFile = ../../../secrets/gitlab/secrets.yaml;
      };
      gl-jws-file = {
        mode = "0400";
        sopsFile = ../../../secrets/gitlab/secrets.yaml;
      };
    };

    services.gitlab = {
      enable = true;
      databasePasswordFile = config.sops.secrets.gl-database-pass.path;
      initialRootPasswordFile = config.sops.secrets.gl-root-pass.path;
      secrets = {
        secretFile = config.sops.secrets.gl-secret.path;
        otpFile = config.sops.secrets.gl-otp.path;
        dbFile = config.sops.secrets.gl-db-file.path;
        jwsFile = config.sops.secrets.gl-jws-file.path;
      };
    };

    services.openssh.enable = true;

    systemd.services.gitlab-backup.environment.BACKUP = "dump";
    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      custom = ''
        redirect http://unix:/run/gitlab/gitlab-workhorse.socket
      '';
    };
    tailscale.dns.enable = true;
  };
}
