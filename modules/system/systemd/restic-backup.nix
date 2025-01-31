{ pkgs, ... }:
{
  # -------------------- 
  # System Backup Service
  # -------------------- 
  systemd.services = {
    restic-backup = {
      enable = true;
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      description = "Restic Backup System";
      serviceConfig = {
        User = "ayushmaan";
        ExecStart = ''/etc/scripts/backup.sh'';
      };
    };

    # restic-check = {
    #   enable = true;
    #   wants = [ "network-online.target" ];
    #   after = [ "network-online.target" ];
    #   description = "Restic Check System";
    #   serviceConfig = {
    #     User = "ayushmaan";
    #     ExecStart = ''/etc/scripts/restic.sh'';
    #   };
    # };

  };

  # -------------------- 
  # System Timers
  # -------------------- 
  systemd.timers = {
    # Backup Timer
    restic-backup = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        #OnBootSec = "10m";
        OnCalendar = "daily";
        Persistent = true;
        Unit = "restic-backup.service";
      };
    };

    # restic-check = {
    #   wantedBy = [ "timers.target" ];
    #   timerConfig = {
    #     OnBootSec = "10m";
    #     OnCalendar = "weekly";
    #     Persistent = true;
    #     Unit = "restic-check.service";
    #   };
    # };

  };
}
