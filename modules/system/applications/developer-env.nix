# Applications
{ pkgs, ... }:
{
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
    texliveSmall

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
    ### For image.nvim
    imagemagick
    luajitPackages.magick

  ];
}
