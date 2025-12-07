{
  lib,
  pkgs,
  filesystem,
  ...
}:
let
  # zfsCompatibleKernelPackages = lib.filterAttrs (
  #   name: kernelPackages:
  #   (builtins.match "linux_[0-9]+_[0-9]+" name) != null
  #   && (builtins.tryEval kernelPackages).success
  #   && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  # ) pkgs.linuxKernel.packages;

  # latestKernelPackage = lib.last (
  #   lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
  #     builtins.attrValues zfsCompatibleKernelPackages
  #   )
  # );
  # pinnedKernelPackage = pkgs.linuxPackagesFor (
  #   pkgs.linuxKernel.kernels.linux_6_17.override {
  #     argsOverride = rec {
  #       src = pkgs.fetchurl {
  #         url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
  #         sha256 = "0ibayrvrnw2lw7si78vdqnr20mm1d3z0g6a0ykndvgn5vdax5x9a";
  #       };
  #       version = "6.17.10";
  #       modDirVersion = "6.17.10";
  #     };
  #   }
  # );

in
{
  config = lib.mkMerge [
    (lib.mkIf (filesystem == "zfs") {
      #boot.kernelPackages = pinnedKernelPackage;
      boot.kernelPackages = pkgs.linuxPackages_6_17;
    })
    (lib.mkIf (filesystem != "zfs") {
      boot.kernelPackages = pkgs.linuxPackages_zen;
      #boot.kernelPackages = pkgs.linuxPackages_latest;
    })
    {
      # Bootloader.
      boot.kernel.sysctl."kernel.sysrq" = 1; # enable ALT+SysRq+f oom killer
      boot.kernelParams = [
        "quiet"
      ];
      boot.loader = {
        efi.canTouchEfiVariables = true;
        timeout = lib.mkDefault 5;
        systemd-boot = {
          enable = true;
          editor = false;
          consoleMode = "max";
        };
      };

      # Add swapfile
      # swapDevices = [
      #   {
      #     device = "/var/lib/swapfile";
      #     size = 16 * 1024;
      #     randomEncryption.enable = true;
      #   }
      # ];
    }
  ];
}
