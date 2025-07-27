{ inputs, config, pkgs, lib, desktop, hostname, system, username, ... }: {
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
                  type = "calendar";
                  first-day-of-week = "monday";
                }
                {
                  type = "rss";
                  limit = 10;
                  collapse-after = 3;
                  cache = "12h";
                  feeds = [
                    #{ url = ""; title = "<title>"; limit = 4; }
                  ];
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
                  type = "markets";
                  markets = [
                    {
                      symbol = "SPY";
                      name = "S&P 500";
                    }
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "NVDA";
                      name = "NVIDIA";
                    }
                    {
                      symbol = "AAPL";
                      name = "Apple";
                    }
                    {
                      symbol = "MSFT";
                      name = "Microsoft";
                    }
                  ];
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

  };
}
