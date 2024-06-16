{ config, lib, modulesPath, ... }: {
  disabledModules = [
    (modulesPath + "services/networking/sing-box.nix")
  ];
  services.sing-box = {
    enable = true;
    configUrlFilePath = config.age.secrets."sing-box-config-url".path;
  };

  networking.networkmanager.enable = true;

  services.openssh.enable = lib.mkForce false;
}
