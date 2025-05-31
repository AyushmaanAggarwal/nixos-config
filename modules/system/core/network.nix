{
  config,
  pkgs,
  ...
}: {
  # Tailscale VPN
  services.tailscale = {
    enable = true;
    extraDaemonFlags = ["--no-logs-no-support"];
  };

  # General Networking
  networking = {
    hostName = "thegram";
    nameservers = ["127.0.0.1" "::1"];
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
    };
    firewall.checkReversePath = "loose";
    # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  };
  # Firewall
  networking.firewall.enable = true;

  # DNS Encryption
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv4_servers = true;
      ipv6_servers = false;
      block_ipv6 = true;

      dnscrypt_servers = true;
      doh_servers = true;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = false;

      cache_size = 8192;
      cache_min_ttl = 2400;
      cache_max_ttl = 86400;
      cache_neg_min_ttl = 60;
      cache_neg_max_ttl = 600;

      bootstrap_resolvers = ["100.100.100.100:53" "9.9.9.9:53" "149.112.112.112:53" "1.1.1.1:53"];
      forwarding_rules = "/etc/nixos/services/networking/forwarding-rules.txt";
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        refresh_delay = 72;
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = [
        "quad9-doh-ip4-port443-filter-pri"
        "quad9-doh-ip4-port443-filter-alt"
        "quad9-doh-ip4-port443-filter-alt2"
        "quad9-doh-ip4-port5053-filter-pri"
        "quad9-doh-ip4-port5053-filter-alt"
        "quad9-doh-ip4-port5053-filter-alt2"
      ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
}
