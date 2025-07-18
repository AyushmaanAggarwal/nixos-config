{ pkgs, ... }:
let
  light_color = "#CFC8B8";
  lighter_dark = "#525250";
  dark_color = "#191916";
  selected_color = "#7B92B9"; # goes well with dark colors
in
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      unmap [normal] j
      unmap [normal] k
      unmap [fullscreen] j
      unmap [fullscreen] k

      map [normal] j navigate next
      map [normal] k navigate previous
      map [fullscreen] j navigate next
      map [fullscreen] k navigate previous

      map [normal] b focus_inputbar ":bmark current"
      map [fullscreen] b focus_inputbar ":bmark current"
      map [normal] n focus_inputbar ":bjump current"
      map [fullscreen] n focus_inputbar ":bjump current"
    '';
    mappings = {
      i = "recolor";
    };
    options = {
      # Automatically Center Page
      zoom-center = true;
      vertical-center = true;

      # Invert page colors
      recolor = true;
      recolor-keephue = true;
      recolor-darkcolor = light_color;
      recolor-lightcolor = dark_color;

      # Reconfigure colors
      inputbar-fg = light_color;
      inputbar-bg = dark_color;
      index-active-bg = selected_color;
      index-active-fg = dark_color;
      index-bg = dark_color;
      index-fg = light_color;
      notification-bg = lighter_dark;
      notification-fg = light_color;
      statusbar-bg = dark_color;
      statusbar-fg = light_color;
    };
  };
}
