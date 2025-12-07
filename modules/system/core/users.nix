{
  username,
  ...
}:
{
  users.mutableUsers = true;
  users.users.root = {
    initialHashedPassword = "$y$j9T$UTgPaJmN.gmA/TlxACfvP0$Q4PEQLVvBeCWFYYmZOvA3eJDU5GsoZrh6rLG6mptYy9";
  };

  users.users.${username} = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
    ];
    initialHashedPassword = "$y$j9T$tCTWlRyMEbQFgQbrmNFXA0$pIIAbnbwC712dNEqLD7Xypr/Ll5zk.yhCjsu.Llzri8";
  };

}
