{
  inputs,
  outputs,
  config,
  pkgs,
  home-manager,
  desktop,
  hostname,
  system,
  username,
  ...
}: {
  imports = [
    ./applications.nix
    ./developer-enviroment.nix

    ./core/default.nix
    ./systemd/default.nix
    ./services/default.nix
    ./desktop/default.nix

    #inputs.sops-nix.nixosModules.sops
  ];
}
