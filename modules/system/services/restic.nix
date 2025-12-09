# Backup Services
{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  secrets-file = ../../../secrets/thegram/backups.yaml;
  general_restic_config = {
    initialize = false;
    user = "${username}";
    paths = [
      "/home/${username}/.dotfiles/"
      "/home/${username}/.config/"
      "/home/${username}/Zotero/"
      "/home/${username}/Documents/"
      "/home/${username}/Pictures/"
    ];
    exclude = [
      "*.iso"
    ];

    inhibitsSleep = false;
    passwordFile = config.sops.secrets.encryption.path;
    rcloneOptions.password-command = "cat ${config.sops.secrets.configuration.path}";
    rcloneConfigFile = "/home/${username}/.config/rclone/rclone.conf";

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
      "--keep-yearly 2"
    ];
    extraBackupArgs = [
      "--verbose"
      "--skip-if-unchanged"
    ];

    runCheck = true;
    checkOpts = [ "--read-data-subset=5%" ];
  };
in
{
  users.users.${username}.packages = with pkgs; [
    restic
  ];

  sops.secrets.configuration = {
    owner = "${username}";
    group = "users";
    mode = "0400";
    sopsFile = secrets-file;
  };

  sops.secrets.encryption = {
    owner = "${username}";
    group = "users";
    mode = "0400";
    sopsFile = secrets-file;
  };

  users.users.restic = {
    isNormalUser = true;
  };

  security.wrappers.restic = {
    source = "${pkgs.restic.out}/bin/restic";
    owner = "restic";
    group = "users";
    permissions = "u=rwx,g=,o=";
    capabilities = "cap_dac_read_search=+ep";
  };

  services.restic.backups = {
    gdrive = lib.mkMerge [
      {
        repository = "rclone:EncryptedDrive:NixOS/restic-backup";
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      }
      general_restic_config
    ];

  };
}
