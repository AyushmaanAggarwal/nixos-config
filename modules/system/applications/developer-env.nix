# Applications
{ pkgs, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-small enumitem xifthen ifmtarg fontawesome5 roboto sourcesanspro
      tcolorbox tikzfill;
  });
in {
  users.users.ayushmaan.packages = with pkgs; [
    # Editors
    vscodium
    neovim

    conda
    devenv
    direnv
    gnumake # For makefiles
    pandoc
    quarto
    tex

    # Nix Packages
    treefmt
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
    ### For image.nvim
    imagemagick
    luajitPackages.magick

  ];
}
