{ inputs, config, lib, pkgs, ... }:
{
  options = {
    developer-env.enable = lib.mkOption {
      type = lib.types.bool;
      description = "";
      default = false;
    };
    developer-env.user = lib.mkOption {
      type = lib.types.str;
      description = "Install developer user packages";
      default = "ayushmaan";
    };
  };
  config = lib.mkIf (config.developer-env.enable) {
    users.users.${config.developer-env.user}.packages = with pkgs; [
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
 
      (python3.withPackages (python-pkgs: with python-pkgs; [
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
      ]))
    ];
  };
}
