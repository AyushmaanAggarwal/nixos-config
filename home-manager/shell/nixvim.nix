{ inputs, ... }: {
  imports = [ inputs.nixvim-config.nixosModules.default ];

  programs.nixvim-config.enable = true;
}
