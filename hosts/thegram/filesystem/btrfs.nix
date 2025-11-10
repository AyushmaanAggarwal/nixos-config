{
  config,
  lib,
  filesystem,
  ...
}:
{
  config = lib.mkIf (filesystem == "btrfs") {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/cd92ae6f-30e8-42d7-9ddd-5480f1c0de30";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    boot.initrd.luks.devices."luks-8372492f-b5f6-40d0-a999-85bda82712d4".device =
      "/dev/disk/by-uuid/8372492f-b5f6-40d0-a999-85bda82712d4";

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/D898-0BE4";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    swapDevices = [ ];
  };
}
