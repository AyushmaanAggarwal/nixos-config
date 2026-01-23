# Applications
{
  inputs,
  pkgs,
  username,
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
  users.users.${username}.packages =
    with pkgs;
    [
      # Editors
      vscodium

      conda
      devenv
      direnv
      gnumake # For makefiles
      ansible

      # Documents
      pandoc
      quarto
      tex

      ripgrep
      # Nix Packages
      sops
      treefmt
      nixfmt

    ]
    ++ [ inputs.nixvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default ];
}
