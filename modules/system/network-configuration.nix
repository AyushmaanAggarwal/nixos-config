{ config, pkgs, ... }:

{
  # General Networking
  networking = {
    hostName = "ayu";
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager = {
      enable = true;
      dns = "none";
      wifi.powersave = true;
    };
    # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  };
  # Configure network proxy if necessary networking.proxy.default = "http://user:password@proxy:port/"; networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

      #dnscrypt_servers = true;
      doh_servers = true;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = false;

      #bootstrap_resolvers = [ "9.9.9.9:53" "1.1.1.1:53"];
      #sources.quad9-resolvers = {
      #  urls = [ "https://www.quad9.net/quad9-resolvers.md" ];
      #  minisign_key = "RWQBphd2+f6eiAqBsvDZEBXBGHQBJfeG6G+wJPPKxCZMoEQYpmoysKUN";
      #  cache_file = "quad9-resolvers.md";
      #  prefix = "quad9-";
      #};
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
}
