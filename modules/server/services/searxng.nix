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

  generate_engine_enabled = category: engine_name: {
    name = engine_name;
    engine = engine_name;
    categories = category;
    disabled = false;
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
          (lib.map (generate_engine_enabled "general") [
            # General
            "openlibrary"
            "currency"
            "dictzone"
            "mymemory translated"
            "bing"
            "duckduckgo"
            "google"
            "startpage"
            "wikibooks"
            "wikiquote"
            "wikisource"
            "wikiversity"
            "wikivoyage"
            "ddg definitions"
            "mwmbl"
            "wikidata"
            "wikipedia"
          ])

          (lib.map (generate_engine_enabled "images") [
            # Images
            "devicons"
            "bing images"
            "google images"
            "duckduckgo images"
            "artic"
            "deviantart"
            "flickr"
            "pinterest"
            "unsplash"
            "library of congress"
            "wallhaven"
            "wikicommons.images"
          ])

          (lib.map (generate_engine_enabled "videos") [
            # Videos
            "bing videos"
            "google videos"
            "qwant videos"
            "vimeo"
            "peertube"
            "wikicommons.videos"
            "youtube"
          ])

          (lib.map (generate_engine_enabled "news") [
            # News
            "duckduckgo news"
            "startpage news"
            "google news"
            "wikinews"
            "reuters"
          ])

          (lib.map (generate_engine_enabled "maps") [
            # Maps
            "apple maps"
            "openstreetmap"
            "photon"
          ])

          (lib.map (generate_engine_enabled "it") [
            # IT
            "lib.rs"
            "pypi"
            "askubuntu"
            "caddy.community"
            "stackoverflow"
            "superuser"
            "github"
            "arch linux wiki"
            "nixos wiki"
            "anaconda"
            "hackernews"
          ])

          (lib.map (generate_engine_enabled "science") [
            # Science
            "arxiv"
            "google scholar"
            "semantic scholar"
            "openairedatasets"
            "openairepublications"
            "pdbe"
          ])

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
            ""

          ])
        ];
        # engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        #   # enabled
        #   "duckduckgo"

        #   "mwmbl"
        #   "mwmbl".weight = 0.4;
        #   "bing"
        #   "crowdview"
        #   "crowdview".weight = 0.5;
        #   "ddg definitions"
        #   "ddg definitions".weight = 2;
        #   "wikibooks"
        #   "wikidata"
        #   "wikispecies"
        #   "wikispecies".weight = 0.5;
        #   "wikiversity"
        #   "wikiversity".weight = 0.5;
        #   "wikivoyage"
        #   "wikivoyage".weight = 0.5;
        #   "bing images"
        #
        #   "google images"
        #   "artic"
        #   "deviantart"
        #   "imgur"
        #   "library of congress"
        #   "openverse"
        #   "svgrepo"
        #   "unsplash"
        #   "wallhaven"
        #   "wikicommons.images"
        #   "bing videos"
        #   "google videos"
        #   "qwant videos"
        #   "peertube"
        #   "rumble"
        #   "sepiasearch"
        #   "youtube"
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
