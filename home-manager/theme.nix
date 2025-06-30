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

  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
    gtk-button-images = true;
    gtk-cursor-theme-name = "breeze_cursors";
    gtk-cursor-theme-size = 24;
    gtk-decoration-layout = "icon:minimize,maximize,close";
    gtk-enable-animations = true;
    gtk-font-name = "Noto Sans,  10";
    gtk-icon-theme-name = "breeze";
    gtk-menu-images = true;
    gtk-modules = "colorreload-gtk-module";
    gtk-primary-button-warps-slider = true;
    gtk-sound-theme-name = "ocean";
    gtk-toolbar-style = 3;
    gtk-xft-dpi = 122880;
  };
  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = true;
    gtk-cursor-theme-name = "breeze_cursors";
    gtk-cursor-theme-size = 24;
    gtk-decoration-layout = "icon:minimize,maximize,close";
    gtk-enable-animations = true;
    gtk-font-name = "Noto Sans,  10";
    gtk-icon-theme-name = "breeze";
    gtk-modules = "colorreload-gtk-module";
    gtk-primary-button-warps-slider = true;
    gtk-sound-theme-name = "ocean";
    gtk-xft-dpi = 122880;
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };
}
