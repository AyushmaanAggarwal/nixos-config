{ pkgs, home-manager, ... }:
{
  home.sessionVariables = {
    EDITOR = "nvim";
    GTK_THEME = "Adwaita:dark";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Adwaita";
      size = 12;
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Noto Sans";
      size = 10;
      package = pkgs.noto-fonts;
    };
    iconTheme = {
      name = "Adwaita-Dark";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-Dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-button-images = true;
      gtk-enable-animations = true;
      gtk-menu-images = true;
      gtk-primary-button-warps-slider = true;
      gtk-toolbar-style = 3;
      gtk-xft-dpi = 122880;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-enable-animations = true;
      gtk-primary-button-warps-slider = true;
      gtk-xft-dpi = 122880;
    };
  };

  qt = {
    enable = true;
    style.name = "adwaita-dark";
  };
}
