{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
    "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.36.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # private configs
    # private-config = { url = "git+ssh://git@github.com:froup/nix-config-private.git?shallow=1"; };

    # Non-flake repos
    astronvim = {
      url = "github:AstroNvim/AstroNvim/v3.43.4";
      flake = false;
    };
  };

  outputs = {self, nixpkgs, ...}@inputs:
    let 
      constants = import ./constants.nix;

      # `lib.genAttrs [ "foo" "bar" ] (name: "x_" + name)` => `{ foo = "x_foo"; bar = "x_bar"; }`
      forEachSystem = func: (nixpkgs.lib.genAttrs constants.allSystems func);

      allHostsConfigurations = import ./hosts {
        inherit constants inputs;
        flakeOutputs = self;
      };
    in allHostsConfigurations // {
      formatter = forEachSystem (
       system: nixpkgs.legacyPackages.${system}.alejandra
      );

      # pre-commit hooks for nix code
      checks = forEachSystem (
        system: {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra.enable = true; # formatter
              # deadnix.enable = true; # detect unused variable bindings in `*.nix`
              # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
              # prettier = {
              #   enable = true;
              #   excludes = [".js" ".md" ".ts"];
              # };
            };
          };
        }
      );
    };
}
