# Never tested
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    ollama.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Ollama AI";
      default = false;
    };
  };
  config = lib.mkIf (config.ollama.enable) {
    # --------------------
    # Nvidia Hardware Drivers
    # --------------------
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;
    nixpkgs.config.allowUnfree = true;

    # --------------------
    # Ollama Server
    # --------------------
    services.ollama = {
      port = 11434;
      enable = true;
      acceleration = "cuda";
      # Optional: preload models, see https://ollama.com/library
      loadModels = [ "llama3.2:3b" ];
    };
    services.open-webui.enable = true;

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 11434;
    };
  };
}
