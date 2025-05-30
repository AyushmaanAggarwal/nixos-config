{ pkgs, ... }:

let
  profileName = "ayushmaan";
in
{
  imports = [ 
    ./searchEngines.nix 
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];

    profiles.${profileName} = {
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
