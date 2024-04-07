{
  constants,
  inputs,
  flakeOutputs,
  ...
}: let
  lib = inputs.nixpkgs.lib;
  mylib = import ../lib { inherit lib; };
  vars = import ./vars.nix { inherit inputs; };

  specialArgsForSystem = system: {
    inherit (constants) username fullUsername userEmail;
    inherit mylib;
  } // inputs;

  allSystemSpecialArgs = builtins.mapAttrs (_: specialArgsForSystem) constants.allSystemsAttrset;

  mkNixosConfiguration = {
    system ? "x64-linux",
    hostname,
    extraSpecialArgs ? {},
    username ? constants.username,
    home-manager ? inputs.home-manager,
    nixosModules,
    homeModule,
  }: let
    specialArgs = allSystemSpecialArgs."${system}" // { inherit hostname; } // extraSpecialArgs;
  in lib.nixosSystem {
    inherit specialArgs;
    system = constants.allSystemsAttrset."${system}";
    modules = nixosModules ++ [
      ../secrets/default.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${username}" = homeModule;
      }
    ];
  };
in 
{
  nixosConfigurations = {
    sonata = mkNixosConfiguration vars.sonata;
    concerto = mkNixosConfiguration vars.concerto;
  };
}
