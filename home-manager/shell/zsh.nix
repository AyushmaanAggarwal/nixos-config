{
  pkgs,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    history = {
      size = 10000;
      append = true;
      extended = true;
    };

    dirHashes = {
      # dotfiles
      dotconfig = "$HOME/.dotfiles/config/";
      dotnix = "$HOME/.dotfiles/system/";
      dotnvim = "$HOME/.dotfiles/config/nvim";
      # folders
      books = "$HOME/Documents/Books/";
      downloads = "$HOME/Downloads/";
      obsidian = "$HOME/Documents/Obsidian/";
      # classes
      math = "$HOME/Documents/College/10-Math-W128A/";
    };

    # Your zsh config
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "strug";
    };

    initContent =
      let
        mkBefore = lib.mkOrder 550 ''
          bindkey '^X^I' autosuggest-accept
          source ~/.dotfiles/config/alias_config
        '';
        mkDefault = lib.mkOrder 1000 ''
          (cat ~/.cache/wal/sequences &)
          fastfetch; echo
        '';
        mkAfter = lib.mkOrder 1500 ''
          cd() {
            builtin cd "$@"
            onefetch
          }
        '';
      in
      lib.mkMerge [
        mkBefore
        mkDefault
        mkAfter
      ];

    shellAliases = {
      backup = "/etc/scripts/backup.sh";
      backup_check = "/etc/scripts/restic.sh";
    };
  };
}
