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
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  systemd.services = {
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
    
    system-update = {
      enable = true;
      after = [ "network.target" ];
      description = "Update non-declarative package managers";
      script = ''
      #!/bin/sh
      export PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/ayushmaan/bin
      conda-shell -c "conda update conda --yes"
      flatpak update -y
      #npm update
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
        OnBootSec = "5m";
        OnUnitActiveSec = "24h";
        Unit = "restic-backup.service";
      };
    };

    system-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "4m";
        OnUnitActiveSec = "72h";
        Unit = "system-update.service";
      };
    };

  };
}
