# Applications
{ pkgs, ... }:
{
  users.users.ayushmaan.packages = with pkgs; [
    # Editors
    vscodium
    neovim

    devenv
    direnv
    gnumake # For makefiles
    pandoc
    stable.quarto

    # Nix Packages
    nixfmt-rfc-style

    # Neovim Packages
    ## LSP Dependencies
    gcc
    cargo
    nodejs
    ripgrep

    ## LSP Packages
    marksman
    tree-sitter
    texliveFull
    lua-language-server
    matlab-language-server

  ];
}
