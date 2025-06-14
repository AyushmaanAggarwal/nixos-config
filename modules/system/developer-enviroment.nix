{
  inputs,
  config,
  lib,
  pkgs,
  hostname,
  system,
  username,
  ...
}: {
  options = {
    developer-env.enable = lib.mkOption {
      type = lib.types.bool;
      description = "";
      default = false;
    };
  };
  config = lib.mkIf (config.developer-env.enable) {
    users.users.${username}.packages = with pkgs; [
      gnumake # For makefiles
      jupyter
      numbat
      neovim
      quarto
      pandoc
      ripgrep
      marksman
      tree-sitter
      texliveFull
      lua-language-server

      (python3.withPackages (
        p:
          with p; [
            # Computation Packages
            numpy
            scipy
            sympy

            # Data Structure Packages
            astropy
            pandas
            uncertainties

            # Plotting
            plotly
            matplotlib
            seaborn

            # Helper Packages
            tqdm
            requests
          ]
      ))
    ];
  };
}
