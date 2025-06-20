{pkgs, ...}: {
  imports = [
    ./searchEngines.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta;
    languagePacks = ["en-US"];

    profiles.ayushmaan = {
      isDefault = true;
      userChrome = ''
        /* hides the title bar */
        #titlebar {
          visibility: collapse;
        }

        /* hides the sidebar */
        #sidebar-header {
          visibility: collapse !important;
        }

        /* hides the native tabs */
        #TabsToolbar {
          visibility: collapse;
        }
      '';
    };
  };
}
