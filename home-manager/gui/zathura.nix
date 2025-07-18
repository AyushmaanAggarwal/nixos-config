{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = '''';
    mappings = {
      i = "recolor";
      l = "navigate next";
      h = "navigate previous";
    };
    options = {

    };
  };
}
