# Applications
{
  inputs,
  pkgs,
  system,
  ...
}:
let
  tex = (
    pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-small
        enumitem
        xifthen
        ifmtarg
        fontawesome5
        roboto
        sourcesanspro
        tcolorbox
        tikzfill
        pdfjam
        lualatex-math
        karnaugh-map
        circuitikz
        xstring
        siunitx
        ;
    }
  );
in
{
  users.users.ayushmaan.packages =
    with pkgs;
    [
      # Editors
      vscodium

      conda
      devenv
      direnv
      gnumake # For makefiles
      pandoc
      quarto
      tex

      ripgrep
      # Nix Packages
      treefmt
      nixfmt-rfc-style

    ]
    ++ [ inputs.nixvim-config.packages.${system}.default ];
}
