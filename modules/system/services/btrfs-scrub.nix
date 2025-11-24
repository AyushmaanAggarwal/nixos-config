{
  config,
  lib,
  pkgs,
  username,
  filesystem,
  ...
}:
{
  options = {
    btrfs-scrub.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Btrfs Periodic Scrub";
      default = filesystem == "btrfs";
    };
  };
  config = {
    # NEED MORE WORK
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
    # --------------------
    # BTRFS Scrub
    # --------------------
    systemd.services = {
      btrfs-scrub = {
        enable = config.btrfs-scrub.enable;
        requires = [ "btrfs-scrub-notify.service" ];
        before = [ "btrfs-scrub-notify.service" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        description = "Btrfs Scrub";
        script = ''
          #!/bin/sh
          /run/current-system/sw/bin/btrfs scrub start -B / > /home/ayushmaan/.local/custom-files/btrfs_scrub
        '';
        serviceConfig = {
          User = "root";
        };
      };

      btrfs-scrub-notify = {
        enable = config.btrfs-scrub.enable;
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        description = "Notify about btrfs scrub";
        script = ''
          #!/bin/sh
          source /home/ayushmaan/.bws/secret.sh
          pushd /home/ayushmaan/.dotfiles/scripts/python/ > /dev/null
          source venv/bin/activate
          scrub_result=$(cat /home/ayushmaan/.local/custom-files/btrfs_scrub)
          python3 slack_notification.py "$scrub_result"
          popd > /dev/null
        '';
        serviceConfig = {
          User = "${username}";
          Type = "oneshot";
        };
      };
    };

    # --------------------
    # BTRFS Scrub Timers
    # --------------------
    systemd.timers = {
      btrfs-scrub = {
        enable = config.btrfs-scrub.enable;
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "monthly";
          Persistent = true;
          Unit = "btrfs-scrub.service";
        };
      };
    };
  };
}
