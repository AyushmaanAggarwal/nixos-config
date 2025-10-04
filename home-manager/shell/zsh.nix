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
      config = "$HOME/.dotfiles/config/";
      nix = "$HOME/.dotfiles/system/";
      nvim = "$HOME/.dotfiles/nixvim";
      # folders
      books = "$HOME/Documents/Books/";
      downloads = "$HOME/Downloads/";
      obsidian = "$HOME/Documents/Obsidian/";
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
          fastfetch --processing-timeout 500; echo
        '';
        mkAfter = lib.mkOrder 1500 ''
          last_repository=
          check_directory_for_new_repository() {
           current_repository=$(git rev-parse --show-toplevel 2> /dev/null)
           
           if [ "$current_repository" ] && \
              [ "$current_repository" != "$last_repository" ]; then
            onefetch
           fi
           last_repository=$current_repository
          }
          cd() {
            builtin cd "$@"
            check_directory_for_new_repository
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
