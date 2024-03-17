{inputs, ...}: {
  g14-wsl-nixos = {
    hostname = "g14-wsl-nixos";
    nixosModules = [
      inputs.nixos-wsl.nixosModules.wsl
      ../hosts/wsl
      ../modules/nixos/wsl.nix
    ];
    homeModule = ../hosts/wsl/home.nix;
  };
  vmware = {
    hostname = "vmware";
    nixosModules = [
      ../hosts/vmware
      ../modules/nixos/desktop.nix
    ];
    homeModule = ../hosts/vmware/home.nix;
  };
  oracle-arm = {
    system = "x64-arm";
    hostname = "oracle-arm";
    nixosModules = [
      ../hosts/oracle
      ../modules/nixos/base
    ];
    homeModule = ../hosts/oracle/home.nix;
  };
}
