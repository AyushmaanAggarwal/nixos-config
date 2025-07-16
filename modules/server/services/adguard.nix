{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./caddy.nix
    ./tailscale.nix
  ];
  options = {
    adguard.enable = lib.mkOption {
      type = lib.types.bool;
      description = "Enables Adguard";
      default = false;
    };
  };

  config = lib.mkIf (config.adguard.enable) {
    networking.firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };

    # --------------------
    # Adguard Configuration
    # --------------------
    services.adguardhome = {
      enable = true;
      host = "127.0.0.1";
      port = 3003;
      openFirewall = true;
      mutableSettings = false;
      settings = {
        users = [
          {
            name = "Tycoon8048";
            password = "$2b$05$z/jLE94TqTsCnQlEhvsyYONTvFqP.ejD4mWF3YfBk9eCccakbdHiu";
          }
        ];
        auth_attempts = 5;
        block_auth_min = 600;
        dns = {
          bind_hosts = [ "127.0.0.1" ];
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "tls://dns.quad9.net"
            "https://base.dns.mullvad.net/dns-query"
            "tls://base.dns.mullvad.net"
          ];
          fallback_dns = [
            "https://security.cloudflare-dns.com/dns-query"
            "tls://security.cloudflare-dns.com"
          ];
          bootstrap_dns = [
            "9.9.9.10"
            "149.112.112.10"
            "1.1.1.1"
          ];
          upstream_mode = "load_balance";
          use_http3_upstreams = true;
          bootstrap_prefer_ipv6 = false;
          blocked_response_ttl = 60; # number of seconds to cached blocked response
          ratelimit = 100; # DDos Protection
          refuse_any = false;
          use_dns64 = false; # used for converting from ipv6 to ipv4
          cache_size = 67108864; # 64 MiB of dns caching
          enable_dnssec = true;

          use_private_ptr_resolvers = true;
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          parental_enabled = false; # Parental control-based DNS requests filtering.
          safe_search = {
            enabled = false; # Enforcing "Safe search" option for search engines, when possible.
          };
        };
        statistics = {
          enabled = true;
        };

        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt" # AdGuard DNS filter
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt" # Peter Lowe's Blocklist
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt" # Dan Pollock's List
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt" # OISD Blocklist Big
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_33.txt" # Steven Black's List
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_49.txt" # HaGeZi's Ultimate Blocklist
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt" # uBlock filters – Badware risks
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt" # AWAvenue Ads Rule
              "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt" # AdGuard DNS Popup Hosts filter
            ];
        schema_version = 29;
      };
    };

    # --------------------
    # Caddy SSL Cert
    # --------------------
    caddy = {
      enable = true;
      port = 3003;
      extraHost = "adguard.server.lan";
      extra_custom_proxy = ''reverse_proxy 127.0.0.1:3003'';
    };
    tailscale.dns.enable = true;
    tailscale.userspace.enable = true;
  };
}
