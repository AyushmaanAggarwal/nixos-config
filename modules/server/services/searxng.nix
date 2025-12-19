{
  inputs,
  config,
  pkgs,
  lib,
  desktop,
  hostname,
  system,
  username,
  ...
}:
let
  url = "https://searxng.tail590ac.ts.net";
  port = 8888;

  user = "searx";
  secrets-file = ../../../secrets/searxng/secret.yaml;
in
{
  imports = [
    ../core/sops-nix.nix
  ];
  options = {
    searxng.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enable searxng";
      default = false;
    };
  };
  config = lib.mkIf (config.searxng.enable) {
    # --------------------
    # Secrets
    # --------------------
    sops.secrets.searx = {
      owner = user;
      group = user;
      mode = "0400";
      sopsFile = secrets-file;
    };

    # --------------------
    # SearXNG
    # --------------------
    services.searx = {
      enable = true;
      redisCreateLocally = true;

      # Rate limiting
      limiterSettings = {
        real_ip = {
          x_for = 1;
          ipv4_prefix = 32;
          ipv6_prefix = 56;
        };

        botdetection = {
          ip_limit = {
            filter_link_local = true;
            link_token = true;
          };
        };
      };

      # UWSGI configuration
      configureUwsgi = false;
      #uwsgiConfig = {
      #  socket = "/run/searx/searx.sock";
      #  http = ":8888";
      #  chmod-socket = "660";
      #};

      # Searx configuration
      settings = {
        # Instance settings
        general = {
          debug = true;
          instance_name = "SearXNG Instance";
          donation_url = false;
          contact_url = false;
          privacypolicy_url = false;
          enable_metrics = false;
        };

        # User interface
        ui = {
          static_use_hash = true;
          default_locale = "en";
          query_in_title = true;
          infinite_scroll = false;
          center_alignment = true;
          default_theme = "simple";
          theme_args.simple_style = "auto";
          search_on_category_select = false;
          hotkeys = "vim";
        };

        # Search engine settings
        search = {
          safe_search = 2;
          autocomplete_min = 2;
          autocomplete = "duckduckgo";
          ban_time_on_fail = 5;
          max_ban_time_on_fail = 120;
        };

        # Server configuration
        server = {
          base_url = url;
          port = port;
          bind_address = "127.0.0.1";
          secret_key = config.sops.secrets.searx.path;
          limiter = true;
          public_instance = true;
          image_proxy = true;
          method = "GET";
        };

        # Search engines
        # engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        #   # enabled
        #   "duckduckgo".disabled = false;

        #   "mwmbl".disabled = false;
        #   "mwmbl".weight = 0.4;
        #   "bing".disabled = false;
        #   "crowdview".disabled = false;
        #   "crowdview".weight = 0.5;
        #   "ddg definitions".disabled = false;
        #   "ddg definitions".weight = 2;
        #   "wikibooks".disabled = false;
        #   "wikidata".disabled = false;
        #   "wikispecies".disabled = false;
        #   "wikispecies".weight = 0.5;
        #   "wikiversity".disabled = false;
        #   "wikiversity".weight = 0.5;
        #   "wikivoyage".disabled = false;
        #   "wikivoyage".weight = 0.5;
        #   "bing images".disabled = false;
        #
        #   "google images".disabled = false;
        #   "artic".disabled = false;
        #   "deviantart".disabled = false;
        #   "imgur".disabled = false;
        #   "library of congress".disabled = false;
        #   "openverse".disabled = false;
        #   "svgrepo".disabled = false;
        #   "unsplash".disabled = false;
        #   "wallhaven".disabled = false;
        #   "wikicommons.images".disabled = false;
        #   "bing videos".disabled = false;
        #   "google videos".disabled = false;
        #   "qwant videos".disabled = false;
        #   "peertube".disabled = false;
        #   "rumble".disabled = false;
        #   "sepiasearch".disabled = false;
        #   "youtube".disabled = false;
        #   # disabled
        #   "brave".disabled = true;
        #   "mojeek".disabled = true;
        #   "qwant".disabled = true;
        #   "curlie".disabled = true;
        #   "wikiquote".disabled = true;
        #   "wikisource".disabled = true;
        #   "currency".disabled = true;
        #   "dictzone".disabled = true;
        #   "lingva".disabled = true;
        #   "brave.images".disabled = true;
        #   "duckduckgo images".disabled = true;
        #   "qwant images".disabled = true;
        #   "1x".disabled = true;
        #   "flickr".disabled = true;
        #   "material icons".disabled = true;
        #   "material icons".weight = 0.2;
        #   "pinterest".disabled = true;
        #   "yacy images".disabled = true;
        #   "brave.videos".disabled = true;
        #   "duckduckgo videos".disabled = true;
        #   "dailymotion".disabled = true;
        #   "google play movies".disabled = true;
        #   "invidious".disabled = true;
        #   "odysee".disabled = true;
        #   "piped".disabled = true;
        #   "vimeo".disabled = true;
        #   "brave.news".disabled = true;
        #   "google news".disabled = true;
        # };

        # Outgoing requests
        outgoing = {
          request_timeout = 1.0;
          max_request_timeout = 15.0;
          pool_connections = 200;
          pool_maxsize = 15;
          enable_http2 = true;
        };

        # Enabled plugins
        enabled_plugins = [
          "Basic Calculator"
          "Hash plugin"
          "Open Access DOI rewrite"
          "Hostnames plugin"
          "Unit converter plugin"
          "Tracker URL remover"
        ];
      };
    };

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = port;
    };

  };
}
