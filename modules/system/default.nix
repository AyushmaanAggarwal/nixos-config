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

    ./core
    ./systemd
    ./services
    ./desktop
    ./scripts
  ];
}
