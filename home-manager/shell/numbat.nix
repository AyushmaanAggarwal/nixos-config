{pkgs, ...}: {
  programs.numbat = {
    enable = true;

    settings = {
      intro-banner = "long";
      prompt = "> ";
      pretty-print = "auto";
      color = "auto";

      exchange-rates.fetching-policy = "on-startup";
    };
  };
  xdg.configFile."numbat/init.nbt".text = ''
    unit kohm: ElectricResistance = kV/A
    unit Mohm: ElectricResistance = MV/A
    unit Gohm: ElectricResistance = GV/A
  '';
}
