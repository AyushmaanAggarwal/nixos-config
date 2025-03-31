{ config, pkgs, ... }:

{
  # NTP Servers
  services.timesyncd = {
    servers = [ 
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
      "3.pool.ntp.org"
    ];
    fallbackServers = [
      "129.6.15.28"    # NIST Fallback Server 1
      "132.163.96.1"   # NIST Fallback Server 2
      "128.138.140.44" # NIST Fallback Server 3
      "time.nist.gov"
    ];
  };
  # General Networking
  networking = {
    hostName = "thegram";
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
    };
    firewall.checkReversePath = "loose";
    # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  };
  # Firewall
  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ]; networking.firewall.allowedUDPPorts = [ ... ]; Or disable the firewall altogether. 
  # networking.firewall.enable = false;
  
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

      bootstrap_resolvers = [ "100.100.100.100:53" "9.9.9.9:53" "149.112.112.112:53" "1.1.1.1:53" "8.8.8.8:53"];
      forwarding_rules = "/etc/nixos/services/networking/forwarding-rules.txt";
      sources.public-resolvers = {
         urls = [
           "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
           "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
         ];
         cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
         minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = [ 
        "quad9-doh-ip4-port443-filter-pri"
        "quad9-doh-ip4-port443-filter-pri"
        "quad9-doh-ip4-port5053-filter-pri"
        "quad9-doh-ip4-port443-filter-alt"
        "quad9-doh-ip4-port5053-filter-alt"
        "quad9-doh-ip4-port443-filter-alt2"
        "quad9-doh-ip4-port5053-filter-alt2" 
      ];

    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  environment.etc = {
    "nixos/services/networking/forwarding-rules.txt" = {
      text = "local $DHCP";
      mode = "0644";
    }; 
  };
 
}
