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
}
