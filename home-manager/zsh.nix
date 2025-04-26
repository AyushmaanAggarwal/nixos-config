{ config, pkgs, ... }:

{
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      #syntaxHighlighting.enable = true;
      history = {
        size = 10000;
      };

      dirHashes = {
        homeconfig = "/etc/nixos/home-manager/";
        scripts = "$HOME/.dotfiles/scripts/";
        dotconfig = "$HOME/.dotfiles/config/";
        dotnix = "$HOME/.dotfiles/system/";
        nvimconfig = "$HOME/.dotfiles/config/nvim";
      };

      # Your zsh config
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "strug";
      };
    initContent = ''
      bindkey '^X^I' autosuggest-accept

      source ~/.dotfiles/config/alias_config
      (cat ~/.cache/wal/sequences &)

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
      fastfetch; echo
      '';

    shellAliases = {
      nrb="nix-rebuild";
      nixupgrade="nix-rebuild switch --upgrade";
      nrbb="nix-rebuild boot --upgrade";
      up="/etc/scripts/nix-update.sh";
      backup="/etc/scripts/backup.sh";
      backup_check="/etc/scripts/restic.sh";
    };

  };
}
