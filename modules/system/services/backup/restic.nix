# Backup Services
{
  config,
  pkgs,
  ...
}:
let
  secrets-file = ../../../../secrets/thegram/backups.yaml;
in
{
  imports = [
    #./restic-etc.nix
    #./restic-systemd.nix
  ];

  users.users.ayushmaan.packages = with pkgs; [
    restic
  ];

  sops.secrets.configuration = {
    owner = "ayushmaan";
    group = "users";
    mode = "0400";
    sopsFile = secrets-file;
  };

  sops.secrets.encryption = {
    owner = "ayushmaan";
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

  services.restic.backups.gdrive = {
    initialize = false;
    user = "ayushmaan";
    repository = "rclone:EncryptedDrive:NixOS/restic-backup";
    paths = [
      "/home/ayushmaan/.dotfiles/"
      "/home/ayushmaan/.config/"
      "/home/ayushmaan/Zotero/"
      "/home/ayushmaan/Documents/"
      "/home/ayushmaan/Pictures/"
    ];
    #exclude

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;

    };
    progressFps = 0.1;
    inhibitsSleep = false;

    passwordFile = config.sops.secrets.encryption.path;
    rcloneOptions = {
      password-command = "cat ${config.sops.secrets.configuration.path}";
    };
    rcloneConfigFile = "/home/ayushmaan/.config/rclone/rclone.conf";

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
}
