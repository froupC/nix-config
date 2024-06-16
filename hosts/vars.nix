{inputs, ...}: {
  sonata = {
    hostname = "sonata";
    nixosModules = [
      inputs.nixos-wsl.nixosModules.wsl
      ../hosts/sonata
      ../modules/nixos/wsl.nix
    ];
    homeModule = ../hosts/sonata/home.nix;
  };
  concerto = {
    hostname = "concerto";
    nixosModules = [
      ../hosts/concerto
      ../modules/nixos/base
    ];
    homeModule = ../hosts/concerto/home.nix;
  };
  fugue = {
    hostname = "fugue";
    nixosModules = [
      ../hosts/fugue
      ../modules/nixos/base
    ];
    minimalNixosModules = [
      ../hosts/fugue/minimal.nix
      ../modules/nixos/base/locale.nix
      ../modules/nixos/base/networking.nix
    ];
    homeModule = ../hosts/fugue/home.nix;
  };
  symphony = {
    hostname = "symphony";
    nixosModules = [
      ../hosts/symphony
      ../modules/nixos/desktop.nix
    ];
    minimalNixosModules = [
      ../hosts/symphony
      ../modules/nixos/base
    ];
    homeModule = ../hosts/symphony/home.nix;
  };
  nixos-iso = {
    hostname = "nixos-iso";
    minimalNixosModules = [
      ../modules/nixos/base/locale.nix
      ../modules/nixos/base/misc.nix
      ../modules/nixos/base/nix.nix
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ({pkgs, hostname, ...}: {
        environment.systemPackages = [
          pkgs.sing-box
        ];
        networking.hostName = "${hostname}";
      })
    ];
  };
}
