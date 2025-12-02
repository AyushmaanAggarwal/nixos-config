# Main Configuration
{ config, ... }:
{
  environment.etc = {
    "scripts/ssh-key" = {
      text = ''
        ssh-keygen -t ed25519 -f /home/proxmox/.ssh/id_ed25519 -N "" -C "server@proxmox"
        eval "$(ssh-agent -s)"
        ssh-add ~/.ssh/id_ed25519
      '';
      mode = "0555";
    };
  };
}
