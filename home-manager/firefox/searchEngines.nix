{ pkgs, ... }:

{
  programs.firefox.profiles.ayushmaan.search = {
    force = true;
    default = "ddg"; privateDefault = "ddg";
    engines = {
      "Nix Packages" = {
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "channel"; value = "unstable"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@np" ];
      };

      "Nix Options" = {
        urls = [{
          template = "https://search.nixos.org/options";
          params = [
            { name = "channel"; value = "unstable"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@no" ];
      };

      "NixOS Wiki" = {
        urls = [{
          template = "https://wiki.nixos.org/w/index.php";
          params = [
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nw" ];
      };

      "Github Nix Code" = {
        urls = [{
          template = "https://github.com/search";
          params = [
            { name = "type"; value = "code"; }
            { name = "q"; value = "lang:nix NOT is:fork {searchTerms}"; }
          ];
        }];
        icon = "https://github.com/favicon.ico";
        definedAliases = [ "@gn" ];
      };

    };
  };
}
