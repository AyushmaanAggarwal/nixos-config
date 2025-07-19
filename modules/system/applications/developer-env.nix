# Applications
{ pkgs, ... }:
let
  # Custom tex package with upgreek
  tex = (
    pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-small
        upgreek
        ;
    }
  );
in
{
  users.users.ayushmaan.packages = with pkgs; [
    # Editors
    vscodium
    neovim

    devenv
    direnv
    gnumake # For makefiles
    pandoc
    quarto
    tex

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
    lua-language-server
    matlab-language-server

  ];
}
