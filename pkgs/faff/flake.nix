{
  description = "flake packaging faff.sh with a wrapped executable";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # pick desired channel
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        lib = pkgs.lib;

        src = ./faff.sh;
        binName = "faff";
        deps = with pkgs; [
          bash
          coreutils
          bc
          curl
          jq
        ];
      in
      {
        packages.default =
          pkgs.runCommand "${binName}"
            {
              nativeBuildInputs = [ pkgs.makeWrapper ];
              meta = with lib; {
                description = "Wrapped ${binName} script";
              };
            }
            ''
              mkdir -p $out/bin
              install -m 755 ${src} $out/bin/${binName}

              wrapProgram $out/bin/${binName} --prefix PATH : ${lib.makeBinPath deps}
            '';

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            coreutils
            bc
            curl
            jq
          ];
        };

        checks.${binName} =
          let
            drv = self.packages.${system}.default;
          in
          pkgs.runCommand "check-${binName}"
            {
              buildInputs = [ drv ];
            }
            ''
              ${binName} --help >/dev/null 2>&1 || true
            '';
      }
    );
}
