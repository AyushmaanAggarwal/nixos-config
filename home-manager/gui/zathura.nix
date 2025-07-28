{ pkgs, ... }:
let
  light_color = "#CFC8B8";
  lighter_dark = "#525250";
  dark_color = "#191916";
  selected_color = "#7B92B9"; # goes well with dark colors
  extraConfigHelper = mode: ''
    unmap [${mode}] j
    unmap [${mode}] k
    unmap [${mode}] l
    unmap [${mode}] h
    unmap [${mode}] <S-l>
    unmap [${mode}] <S-h>

    map [${mode}] j navigate next
    map [${mode}] k navigate previous
    map [${mode}] l scroll down
    map [${mode}] h scroll up
    map [${mode}] <S-l> scroll left
    map [${mode}] <S-h> scroll right

    map [${mode}] b focus_inputbar ":bmark current"
    map [${mode}] n focus_inputbar ":bjump current"
  '';
in {
  programs.zathura = {
    enable = true;
    extraConfig = (extraConfigHelper "normal")
      + (extraConfigHelper "fullscreen") + "";
    mappings = { i = "recolor"; };
    options = {
      # General settings
      seletion-clipboard = "clipboard";

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
      highlight-active-color = selected_color;
      highlight-color = selected_color;
      highlight-fg = light_color;
    };
  };
}
