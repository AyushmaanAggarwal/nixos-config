{
  pkgs,
  lib,
  ...
}:
{
  programs.kitty = lib.mkForce {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      # Fonts
      font_family = "FiraCode Nerd Font Mono Reg";
      font_size = 13;
      symbol_map = "U+E5FF Jetbrains Mono";

      # Environment
      editor = "nvim";
      shell = "zsh";

      # Visual
      scrollback_lines = 10000;
      window_padding_width = 10;
      linux_display_server = "Wayland";
    };
  };
}
