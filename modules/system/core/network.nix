{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Tailscale VPN
  services.tailscale = {
    enable = true;
    extraDaemonFlags = [ "--no-logs-no-support" ];
  };

  # BPF AutoTune
  services.bpftune.enable = true;

  # General Networking
  networking = {
    hostName = "thegram";
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
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
  services.dnscrypt-proxy = {
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

      bootstrap_resolvers = [
        "9.9.9.9:53"
        "149.112.112.112:53"
      ];
      forwarding_rules = "/etc/nixos/services/networking/forwarding-rules.txt";
      captive_portals.map_file = "/etc/nixos/services/networking/captive-portals.txt";
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

  environment.etc = {
    "nixos/services/networking/forwarding-rules.txt" = {
      text = ''
        local $DHCP
        time.cloudflare.com $BOOTSTRAP
      '';
      mode = "0644";
    };
    "nixos/services/networking/captive-portals.txt" = {
      text = ''
        captive.apple.com               17.253.109.201, 17.253.113.202
        connectivitycheck.gstatic.com   64.233.162.94, 64.233.164.94, 64.233.165.94, 64.233.177.94, 64.233.185.94, 74.125.132.94, 74.125.136.94, 74.125.20.94, 74.125.21.94, 74.125.28.94
        connectivitycheck.android.com   64.233.162.100, 64.233.162.101, 64.233.162.102, 64.233.162.113, 64.233.162.138, 64.233.162.139
        www.msftncsi.com                2.16.106.89, 2.16.106.91, 23.0.175.137, 23.0.175.146, 23.192.47.155, 23.192.47.203, 23.199.63.160, 23.199.63.184, 23.199.63.208, 23.204.146.160, 23.204.146.163, 23.46.238.243, 23.46.239.24, 23.48.39.16, 23.48.39.48, 23.55.38.139, 23.55.38.146, 23.59.190.185, 23.59.190.195
        dns.msftncsi.com                131.107.255.255, fd3e:4f5a:5b81::1
        www.msftconnecttest.com         13.107.4.52
        ipv6.msftconnecttest.com        2a01:111:2003::52
        ipv4only.arpa                   192.0.0.170, 192.0.0.171
      '';
      mode = "0644";
    };
  };

}
