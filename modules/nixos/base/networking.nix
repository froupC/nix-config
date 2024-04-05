{
  hostname,
  lib,
  ...
}: {
  networking.hostName = "${hostname}";

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = lib.mkDefault false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      PermitRootLogin = "prohibit-password"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };
}
