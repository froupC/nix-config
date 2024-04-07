{...}: {
  # avoid confliction with systemd-networkd
  networking.useDHCP = false;

  systemd.network.enable = true;
  services.resolved.enable = true;

  systemd.network.networks.eth0 = {
    DHCP = "yes";
    matchConfig.Name = "eth0";
  };
  services.resolved.fallbackDns = [
    "8.8.8.8"
  ];

  networking.usePredictableInterfaceNames = false;
}
