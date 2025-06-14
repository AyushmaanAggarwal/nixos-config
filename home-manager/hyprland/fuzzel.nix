{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    fuzzel.enable = lib.mkOption {
      type = lib.types.bool;
      description = "";
      default = false;
    };
  };
  config = lib.mkIf (config.fuzzel.enable) {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          dpi-aware = "no";
          width = 10;
          font = "Hack:weight=bold:size=15";
          line-height = 20;
          fields = "name,generic,comment,categories,filename,keywords";
          layer = "overlay";
        };
        border = {
          radius = 1;
          width = 0;
        };

        colors = {
          background = "191916ff";
          border = "191916ff";
          text = "CFC8B8ff";
          match = "68738Aff";
          selection-text = "CFC8B8ff";
          selection = "525250ff";
        };
        dmenu.exit-immediately-if-empty = "yes";
      };
    };
  };
}
