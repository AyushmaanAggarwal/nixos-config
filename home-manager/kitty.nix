{ pkgs, lib, ... }:
{
  programs.kitty = lib.mkForce {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      scrollback_lines = 10000;
      font_family = "FiraCode Nerd Font Mono Reg";
      symbol_map = "U+E5FF Jetbrains Mono";
      window_padding_width = 10;
      editor = "nvim";
      linux_display_server = "Wayland";
    };  
  };
}
