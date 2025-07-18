{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      unmap [normal] j
      unmap [normal] k
      unmap [fullscreen] j
      unmap [fullscreen] k

      map [normal] j navigate next
      map [normal] k navigate previous
      map [fullscreen] j navigate next
      map [fullscreen] k navigate previous
    '';
    mappings = {
      i = "recolor";
    };
    options = {

    };
  };
}
