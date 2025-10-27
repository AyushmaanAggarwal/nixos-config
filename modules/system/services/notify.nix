{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}:
{
  config = lib.mkMerge (
    [
      {
        users.users.ayushmaan.packages = with pkgs; [ ntfy-sh ];
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
    ++ (lib.forEach [ "restic-backup" ] (service: {
      systemd.services."${service}".serviceConfig = {
        OnSuccess = "${service}-success";
        OnFailure = "${service}-failure";
      };
      systemd.services."${service}-success" = {
        enable = config.systemd.services."${service}".enable;
        description = "Notify on ${service} Service Success";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.ntfy-sh}/bin/ntfy publish --title="Systemd Succeeded: ${service}" --priority=low thegram     "${service} just finished running"'';
        };
      };
      systemd.services."${service}-failure" = {
        enable = config.systemd.services."${service}".enable;
        description = "Notify on ${service} Service Failure";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.ntfy-sh}/bin/ntfy publish --title="Systemd Failure: ${service}" --priority=low thegram     "${service} just failed to run \n$(systemctl status ${service}.service)"'';
        };
      };
    }))
  );
}
