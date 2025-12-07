# Not ready for use
{ ... }:
{
  programs.git = {
    enable = true;
    signing = {
      key = "";
      signByDefault = true;
    };
    aliases = {
      new = "checkout -b";
      s = "status -sb";
      a = "add .";
      c = "commit -aS --verbose";
      ca = "commit -aS --verbose --amend";
      m = "merge";
      l = "log";
    };
    extraConfig = {
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      commit.gpgsign = true;
      gpg.format = "ssh";
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
}
