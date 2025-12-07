{
  config,
  pkgs,
  lib,
  username,
  ...
}:
{
  config = lib.mkMerge (
    [
      {
        users.users.${username}.packages = with pkgs; [ ntfy-sh ];
        environment.etc."ntfy/client.yaml" = {
          text = ''
            default-host: https://ntfy.tail590ac.ts.net
          '';
          user = "root";
          group = "root";
          mode = "0644";
        };
      }
    ]
    ++ (lib.forEach [ "restic-backups-gdrive" "restic-backups-pve" ] (service: {
      systemd.services."${service}" = {
        onSuccess = [ "${service}-success.service" ];
        onFailure = [ "${service}-failure.service" ];
      };

      systemd.services."${service}-success" = {
        enable = config.systemd.services."${service}".enable;
        description = "Notify on ${service} Service Success";
        wantedBy = [ "${service}.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.ntfy-sh}/bin/ntfy publish --title="Systemd Succeeded: ${service}" --config="/etc/ntfy/client.yaml" --priority=low thegram "${service} just finished running"'';
        };
      };

      systemd.services."${service}-failure" = {
        enable = config.systemd.services."${service}".enable;
        description = "Notify on ${service} Service Failure";
        wantedBy = [ "${service}.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.ntfy-sh}/bin/ntfy publish --title="Systemd Failure: ${service}" --config="/etc/ntfy/client.yaml" --priority=low thegram     "${service} just failed to run: $(systemctl status ${service}.service)"'';
        };
      };
    }))
  );
}
