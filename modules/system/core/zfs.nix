# This is based off of
# https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html
# https://wiki.nixos.org/wiki/ZFS
{
  inputs,
  config,
  lib,
  pkgs,
  hostID,
  username,
  ...
}:
{
  # Bootloader
  boot.kernelParams = [ "zfs.zfs_arc_max=4294967296" ]; # 4 GiB of arc
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    requestEncryptionCredentials = true;
    passwordTimeout = 600; # Wait 5 minutes on boot for password
    forceImportRoot = false;
  };

  security.pam.zfs = {
    enable = true; # Enable unlocking home dataset at login
    noUnmount = false;
    homes = "thegram/zoot/home";
  };

  # Maintenance

  services.sanoid = {
    enable = true;
    extraArgs = [
      "--verbose"
      "--readonly"
    ];
    datasets."thegram/zoot/home" = {
      hourly = 12;
      daily = 7;
      monthly = 1;
      yearly = 0;
      script_timeout = 0;
      recursive = false;
      #pruning_script
      #pre_snapshot_script
      #post_snapshot_script
      #no_inconsistent_snapshot
      #force_post_snapshot_script
      autosnap = true;
      autoprune = true;
    };
  };

  services.syncoid = {
    enable = true;
    interval = "*-*-* *:15:00";
    commonArgs = [ ];
    sshKey = "/home/${username}/.ssh/id_ed25519";
    user = username;
    group = "users";
    commands."home-pve" = {
      extraArgs = [ ];
      useCommonArgs = true;
      source = "thegram/zoot/home";
      target = "ayushmaan@pve:rpool/thegram/syncoid";
      sendOptions = "vw";
      #recvOptions = "";
      recursive = false;
    };
    commands."home-sanback" = {
      extraArgs = [ ];
      useCommonArgs = true;
      source = "thegram/zoot/home";
      target = "samback/thegram/syncoid";
      sendOptions = "vw";
      #recvOptions = "";
      recursive = false;
    };

  };

  services.zfs.autoScrub = {
    enable = true;
    interval = "monthly";
    pools = [ ]; # scrub all pools
  };

  services.zfs.trim = {
    enable = true;
    interval = "weekly";
  };

  # Notification Settings
  services.zfs.zed = {
    settings = {
      # send notification if scrub succeeds
      ZED_NOTIFY_VERBOSE = true;

      ZED_NTFY_TOPIC = "thegram";
      ZED_NTFY_URL = "https://ntfy.tail590ac.ts.net/";
      # ZED_NTFY_ACCESS_TOKEN=""
    };
  };

  networking.hostId = hostID;
}
