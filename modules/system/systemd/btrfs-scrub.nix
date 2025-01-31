{ pkgs, ... }:
{
  # -------------------- 
  # BTRFS Scrub
  # -------------------- 
  systemd.services = {
    btrfs-scrub = {
      enable = true;
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
      enable = true;
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
        User = "ayushmaan";
        Type = "oneshot";
      };
    };

  };

  # -------------------- 
  # BTRFS Scrub Timers
  # -------------------- 
  systemd.timers = {
    btrfs-scrub = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "monthly";
        Persistent = true;
        Unit = "btrfs-scrub.service";
      };
    };
  };
}
