{ pkgs, ... }:
{
  # -------------------- 
  # System Services
  # -------------------- 
  systemd.user.services = {
    # Authentication Agent
    polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  systemd.services = {
    system-update = {
      enable = true;
      after = [ "network.target" ];
      description = "Update non-declarative package managers";
      script = ''
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin
      conda-shell -c "conda update conda --yes"
      flatpak update --assumeyes --noninteractive --system
      #npm update
      '';
      serviceConfig = {
        User = "ayushmaan";
        Type = "oneshot";
      };
    };

    # Backup Service
    restic-backup = {
      enable = true;
      after = [ "network.target" ];
      description = "Restic Backup System";
      serviceConfig = {
        User = "ayushmaan";
        ExecStart = ''/etc/scripts/backup.sh'';
      };
    };

    # Btrfs Scrub
    btrfs-scrub = {
      enable = true;
      requires = [ "btrfs-scrub-notify.service" ];
      before = [ "btrfs-scrub-notify.service" ];
      after = [ "network.target" ];
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
      after = [ "network.target" ];
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
  # System Timers
  # -------------------- 
  systemd.timers = {
    # Backup Timer
    restic-backup = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10m";
        OnCalender = "daily";
        Persistent = true;
        Unit = "restic-backup.service";
      };
    };

    system-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "10m";
        OnUnitActiveSec = "weekly";
        Unit = "system-update.service";
      };
    };

    btrfs-scrub = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalender = "monthly";
        Persistent = true;
        Unit = "btrfs-scrub.service";
      };
    };

  };
}
