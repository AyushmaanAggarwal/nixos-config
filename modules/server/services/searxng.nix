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

  # Helper
  engine_enabled_helper =
    category:
    { engine_name, weight_value }:
    {
      name = engine_name;
      engine = engine_name;
      categories = category;
      disabled = false;
      weight = weight_value;
    };

  engine_disabled_helper = engine_name: {
    name = engine_name;
    engine = engine_name;
    disabled = true;
  };

  # Generators
  generate_enabled_engines =
    catagory: engine_attrs:
    lib.map (engine_enabled_helper catagory) (
      lib.mapAttrsToList (name: value: {
        engine_name = name;
        weight_value = value;
      }) engine_attrs
    );

  generate_disabled_engines = engines: (lib.map engine_disabled_helper engines);

  generate_categories = cat_name: {
    cat_name = { };
  };

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
      # limiterSettings = {
      #   real_ip = {
      #     x_for = 1;
      #     ipv4_prefix = 32;
      #     ipv6_prefix = 56;
      #   };

      #   botdetection = {
      #     ip_limit = {
      #       filter_link_local = true;
      #       link_token = true;
      #     };
      #   };
      # };

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
          url_formatting = "pretty";
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

        # Catagories
        categories_as_tabs = lib.map generate_categories [
          "general"
          "images"
          "videos"
          "news"
          "map"
          "it"
          "science"
        ];

        # Search engines
        engines = (
          lib.lists.concatLists [
            (generate_enabled_engines "general" {
              "duckduckgo" = 100;
              "google" = 90;
              "bing" = 70;
              "openlibrary" = 50;
              "currency" = 10;
              "dictzone" = 10;
              "startpage" = 10;
              "mwmbl" = 10;
              "wikipedia" = 10;
            })
            (generate_enabled_engines "images" {
              "google images" = 100;
              "duckduckgo images" = 90;
              "bing images" = 60;
              "pinterest" = 40;
              "unsplash" = 40;
              "wikicommons.images" = 40;
              "devicons" = 10;
              "artic" = 10;
              "deviantart" = 10;
              "flickr" = 10;
              "wallhaven" = 10;
            })

            (generate_enabled_engines "videos" {
              "youtube" = 100;
              "google videos" = 50;
              "bing videos" = 30;
              "qwant videos" = 20;
              "vimeo" = 10;
              "peertube" = 10;
              "wikicommons.videos" = 10;
            })

            (generate_enabled_engines "news" {
              "duckduckgo news" = 100;
              "reuters" = 100;
              "startpage news" = 50;
              "google news" = 50;
              "wikinews" = 20;
            })

            (generate_enabled_engines "maps" {
              "apple maps" = 100;
              "openstreetmap" = 100;
            })

            (generate_enabled_engines "it" {
              "arch linux wiki" = 100;
              "nixos wiki" = 80;
              "github" = 80;
              "stackoverflow" = 75;
              "superuser" = 75;
              "askubuntu" = 60;
              "hackernews" = 50;
              "lib.rs" = 20;
              "pypi" = 20;
              "caddy.community" = 10;
              "anaconda" = 10;
            })

            (generate_enabled_engines "science" {
              "arxiv" = 100;
              "google scholar" = 80;
              "semantic scholar" = 60;
              "openairedatasets" = 50;
              "openairepublications" = 50;
              "pdbe" = 10;
            })

            (generate_disabled_engines [
              # General
              "lingva"
              "mozhi"
              "brave"
              "mojeek"
              "presearch"
              "presearch videos"
              "qwant"
              "wiby"
              "yahoo"
              "seznam"
              "naver"
              "wikibooks"
              "wikispecies"
              "ask"
              "crowdview"
              "encyclosearch"
              "right dao"
              "searchmysite"
            ])
          ]
        );

        # Outgoing requests
        outgoing = {
          retries = 3;
          request_timeout = 5.0;
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
