{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    historyLimit = 5000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      set -gq allow-passthrough on
      set -g visual-activity off
    '';

  };
}
