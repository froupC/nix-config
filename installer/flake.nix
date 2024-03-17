{
  description = "NixOS configuration for deployment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    nixpkgs,
    nixos-hardware,
    ...
  }: {
    nixosConfigurations = {
      vmware = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {username = "froup"; hostname = "vmware"; fullUsername = "Froup See";};
        modules = [
          {networking.hostName = "vmware";}

          ./configuration.nix

          ../modules/nixos/base/locale.nix
          ../modules/nixos/base/networking.nix
          ../modules/nixos/base/user-group.nix
          ../modules/nixos/base/misc.nix

          ../hosts/vmware/hardware-configuration.nix
          ../hosts/vmware/impermanence.nix
        ];
      };

    };
  };
}
