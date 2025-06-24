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
    ./applications

    ./core
    ./services
    ./desktop
    ./scripts
  ];
}
