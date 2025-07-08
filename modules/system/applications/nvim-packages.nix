# Applications
{
  outputs,
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.ayushmaan.packages = with pkgs; [
    neovim

    # LSP Package Dependencies
    nodejs
    cargo
    gcc
    
    # LSP Packages
    marksman
    tree-sitter
    texliveFull
    lua-language-server
    matlab-language-server
  ];
}
