{ config, pkgs, ... }:

let
  # Use servers reachable over IPv6 -- Do not enable if you don't have IPv6 connectivity
  hasIPv6Internet = false;
in
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
      ipv6_servers = hasIPv6Internet;
      block_ipv6 = ! hasIPv6Internet;

      require_dnssec = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      server_names = [ "cloudflare" "cloudflare-ipv6"];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
}
