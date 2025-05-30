{pkgs, ...}: {
  programs.fd = {
    enable = true;
    hidden = true;
    extraOptions = [
      "--ignore-case"
    ];
  };
}
