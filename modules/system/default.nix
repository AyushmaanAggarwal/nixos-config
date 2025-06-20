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

    ./core
    ./systemd
    ./services
    ./desktop
    ./scripts
  ];
}
