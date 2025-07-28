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
                  widgets = [
                    {
                      type = "monitor";
                      cache = "1m";
                      title = "Self Hosted";
                      sites = [
                        {
                          title = "uptime";
                          url = "https://uptime.${tailurl}";
                          icon = "sh:uptime-kuma";
                        }
                        {
                          title = "adguard";
                          url = "https://adguard.${tailurl}";
                          icon = "sh:adguard-home";
                        }
                        {
                          title = "jellyfin";
                          url = "https://jellyfin.${tailurl}";
                          icon = "sh:jellyfin";
                        }
                        {
                          title = "immich";
                          url = "https://immich.${tailurl}";
                          icon = "sh:immich";
                        }
                        {
                          title = "mealie";
                          url = "https://mealie.${tailurl}";
                          icon = "sh:mealie";
                        }
                        {
                          title = "ntfy";
                          url = "https://ntfy.${tailurl}";
                          icon = "sh:ntfy";
                        }

                      ];
                    }
                    {
                      type = "bookmarks";
                      groups = [
                        {
                          title = "NixOS";
                          color = "200 50 50";
                          links = [
                            {
                              title = "NixOS Wiki";
                              url = "https://wiki.nixos.org/";
                            }
                            {
                              title = "NixOS Packages";
                              url =
                                "https://search.nixos.org/packages?channel=unstable";
                            }
                            {
                              title = "NixOS Options";
                              url =
                                "https://search.nixos.org/options?channel=unstable";
                            }
                          ];
                        }
                        {
                          title = "College";
                          color = "64 146 88";
                          links = [
                            {
                              title = "CalCentral";
                              url = "https://calcentral.berkeley.edu/";
                            }
                            {
                              title = "BCourses";
                              url = "https://bcourses.berkeley.edu";
                            }
                            {
                              title = "Gradescope";
                              url = "https://gradescope.com/auth/saml/berkeley";
                            }

                          ];

                        }

                        {
                          title = "Entertainment";
                          color = "10 70 50";
                          links = [
                            {
                              title = "Netflix";
                              url = "https://netflix.com/";
                            }
                            {
                              title = "Formula 1";
                              url = "https://f1tv.formula1.com/";
                            }
                            {
                              title = "YouTube";
                              url = "https://youtube.com/";
                            }
                            {
                              title = "Prime Video";
                              url = "https://primevideo.com/";
                            }
                          ];
                        }
                        {
                          title = "Social";
                          color = "200 50 50";
                          links = [{
                            title = "Reddit";
                            url = "https://www.reddit.com/";
                          }];
                        }

                      ];
                    }

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
