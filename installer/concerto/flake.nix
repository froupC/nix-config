{
  description = "NixOS configuration for concerto";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    ...
  }: {
    nixosConfigurations = {
      concerto = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // { username = "froup"; hostname = "concerto"; fullUsername = "Froup See"; };
        modules = [
          ./configuration.nix

          ../../hosts/concerto/boot.nix
          ../../hosts/concerto/filesystem.nix
          ../../hosts/concerto/network.nix

          ../../modules/nixos/base/locale.nix
          ../../modules/nixos/base/networking.nix
          # ../../modules/nixos/base/user-group.nix
        ];
      };
    };

    packages.x86_64-linux = {
      image = self.nixosConfigurations.concerto.config.system.build.diskoImages;
    };
  };
}
