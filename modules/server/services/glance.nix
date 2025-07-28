{ inputs, config, pkgs, lib, desktop, hostname, system, username, ... }:
let tailurl = "tail590ac.ts.net";
in {
  imports = [

  ];
  options = {
    glance.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable glance";
      default = false;
    };
    glance.port = lib.mkOption {
      type = lib.types.port;
      description = "Set port for glance";
      default = 8080;
    };
  };
  config = lib.mkIf (config.glance.enable) {
    services.glance = {
      enable = true;
      openFirewall = false;
      settings = {
        server.host = "127.0.0.1";
        server.port = config.glance.port;

        pages = [{
          name = "Home";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "clock";
                  hour-format = "24h";
                  timezones = [
                    {
                      timezone = "Europe/Paris";
                      label = "Paris";
                    }
                    {
                      timezone = "America/New_York";
                      label = "New York";
                    }
                    {
                      timezone = "Asia/Tokyo";
                      label = "Tokyo";
                    }
                  ];
                }

                {
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                # {
                #   type = "rss";
                #   limit = 10;
                #   collapse-after = 3;
                #   cache = "12h";
                #   feeds = [
                #     #{ url = ""; title = "<title>"; limit = 4; }
                #   ];
                # }
                {
                  type = "group";
                  widgets = [{
                    type = "monitor";
                    cache = "1m";
                    title = "Self Hosted";
                    sites = [
                      {
                        title = "proxmox";
                        url = "[proxmox.${tailurl}]";
                        icon = "sh:proxmox";
                      }
                      {
                        title = "uptime";
                        url = "[uptime.${tailurl}]";
                        icon = "sh:uptime";
                      }
                      {
                        title = "adguard";
                        url = "[adguard.${tailurl}]";
                        icon = "sh:adguard";
                      }
                      {
                        title = "jellyfin";
                        url = "[jellyfin.${tailurl}]";
                        icon = "sh:jellyfin";
                      }
                      {
                        title = "immich";
                        url = "[immich.${tailurl}]";
                        icon = "sh:immich";
                      }
                      {
                        title = "mealie";
                        url = "[mealie.${tailurl}]";
                        icon = "sh:mealie";
                      }
                      {
                        title = "ntfy";
                        url = "[ntfy.${tailurl}]";
                        icon = "sh:ntfy";
                      }

                    ];
                  }];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets =
                    [ { type = "hacker-news"; } { type = "lobsters"; } ];
                }
                {
                  type = "videos";
                  channels = [
                    "UCXuqSBlHAE6Xw-yeJA0Tunw" # Linus Tech Tips
                    "UCR-DXc1voovS8nhAvccRZhg" # Jeff Geerling
                    "UCsBjURrPoezykLs9EqgamOA" # Fireship
                    "UCBJycsmduvYEL83R_U4JriQ" # Marques Brownlee
                    "UCHnyfMqiRRG1u-2MsSQLbXA" # Veritasium
                  ];
                }
                {
                  type = "group";
                  widgets = [
                    {
                      type = "reddit";
                      subreddit = "technology";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "selfhosted";
                      show-thumbnails = true;
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  location = "Berkeley, United States";
                  units = "imperial";
                  hour-format = "12h"; # alternatively "24h"
                }
                {
                  type = "change-detection";
                  instance-url = "https://changedetection.${tailurl}/";
                  token = "f26312c1f6364eacff6a2aea89da1104";
                }
                {
                  type = "releases";
                  cache = "1d";
                  repositories = [
                    "glanceapp/glance"
                    "immich-app/immich"
                    "syncthing/syncthing"
                  ];
                }
              ];
            }
          ];

        }];
      };
    };

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = config.glance.port;
    };

    # Need non-userspace networking for device pings
    tailscale.userspace.enable = false;
  };
}
