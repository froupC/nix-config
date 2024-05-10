{ lib, ... }: {
  # avoid confliction with systemd-networkd
  networking.useDHCP = false;

  systemd.network.enable = true;
  services.resolved.enable = true;

  systemd.network.networks.eth0 = {
    address = [ "207.180.226.30/24" ];
    # gateway = [ "207.180.226.1" ];
    dns = [ "213.136.95.10" "213.136.95.11" ];
    matchConfig = {
      Name = "eth0";
    };
    networkConfig = {
      LinkLocalAddressing = "ipv6";
    };
    routes = [
      { routeConfig = {
        Destination = "0.0.0.0/0";
        Gateway = "207.180.226.1";
        GatewayOnLink = true;
      }; }
    ];
    linkConfig = {
      MACAddress = "00:50:56:4b:b4:0c";
      RequiredForOnline = "routable";
    };
  };

  networking.nameservers = [ "213.136.95.10" "213.136.95.11" ];

  services.resolved.fallbackDns = [
    "8.8.8.8#dns.google"
  ];

  networking.usePredictableInterfaceNames = false;

  networking.firewall = {
    enable = lib.mkForce true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ 443 ];
    allowPing = true;
    trustedInterfaces = [ "ve-+" ];
  };

  # for systemd-nspawn containers
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve+" "podman+"];
    externalInterface = "eth0";
  };
}
