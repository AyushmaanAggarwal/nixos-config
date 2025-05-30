{
  pkgs,
  home-manager,
  ...
}: {
  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "Adwaita:dark";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };
}
