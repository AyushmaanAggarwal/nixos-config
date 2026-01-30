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

  generate_engine_enabled =
    category:
    { engine_name, weight_value }:
    {
      name = engine_name;
      engine = engine_name;
      categories = category;
      disabled = false;
      weight = weight_value;
    };
  generate_engine_disabled = engine_name: {
    name = engine_name;
    engine = engine_name;
    disabled = true;
  };
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
        engines = lib.mkMerge [
          (lib.map (generate_engine_enabled "general") (
            lib.zip
              [
                # General
                "duckduckgo"
                "google"
                "bing"
                "openlibrary"
                "currency"
                "dictzone"
                "startpage"
                "mwmbl"
                "wikipedia"
              ]
              [
                100 # "duckduckgo"
                90 # "google"
                70 # "wikipedia"
                50 # "bing"
                10 # "openlibrary"
                10 # "currency"
                10 # "dictzone"
                10 # "startpage"
                10 # "mwmbl"

              ]
          ))

          (lib.map (generate_engine_enabled "images") (
            lib.zip
              [
                # Images
                "google images"
                "duckduckgo images"
                "bing images"
                "devicons"
                "artic"
                "deviantart"
                "flickr"
                "pinterest"
                "unsplash"
                "wallhaven"
                "wikicommons.images"
              ]
              [
                # Images
                100 # "google images"
                90 # "duckduckgo images"
                60 # "bing images"
                40 # "pinterest"
                40 # "unsplash"
                40 # "wikicommons.images"
                10 # "devicons"
                10 # "artic"
                10 # "deviantart"
                10 # "flickr"
                10 # "wallhaven"
              ]
          ))

          (lib.map (generate_engine_enabled "videos") (
            lib.zip
              [
                # Videos
                "bing videos"
                "google videos"
                "qwant videos"
                "vimeo"
                "peertube"
                "wikicommons.videos"
                "youtube"
              ]
              [
                # Videos
                100 # "youtube"
                50 # "google videos"
                30 # "bing videos"
                20 # "qwant videos"
                10 # "vimeo"
                10 # "peertube"
                5 # "wikicommons.videos"
              ]
          ))

          (lib.map (generate_engine_enabled "news") (
            lib.zip
              [
                # News
                "duckduckgo news"
                "startpage news"
                "google news"
                "wikinews"
                "reuters"
              ]
              [
                # News
                100 # "duckduckgo news"
                100 # "reuters"
                50 # "startpage news"
                50 # "google news"
                20 # "wikinews"
              ]
          ))

          (lib.map (generate_engine_enabled "maps") (
            lib.zip
              [
                # Maps
                "apple maps"
                "openstreetmap"
                "photon"
              ]
              [
                # Maps
                100 # "apple maps"
                100 # "openstreetmap"
                10 # "photon"
              ]
          ))

          (lib.map (generate_engine_enabled "it") (
            lib.zip
              [
                # IT
                "arch linux wiki"
                "nixos wiki"
                "github"
                "stackoverflow"
                "superuser"
                "askubuntu"
                "hackernews"
                "lib.rs"
                "pypi"
                "caddy.community"
                "anaconda"
              ]
              [
                # IT
                100 # "arch linux wiki"
                80 # "nixos wiki"
                80 # "github"
                75 # "stackoverflow"
                75 # "superuser"
                60 # "askubuntu"
                50 # "hackernews"
                20 # "lib.rs"
                20 # "pypi"
                10 # "caddy.community"
                10 # "anaconda"
              ]
          ))

          (lib.map (generate_engine_enabled "science") (
            lib.zip
              [
                # Science
                "arxiv"
                "google scholar"
                "semantic scholar"
                "openairedatasets"
                "openairepublications"
                "pdbe"
              ]
              [
                # Science
                100 # "arxiv"
                80 # "google scholar"
                60 # "semantic scholar"
                50 # "openairedatasets"
                50 # "openairepublications"
                10 # "pdbe"
              ]
          ))

          (lib.map generate_engine_disabled [
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
        ];

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
