# This file defines overlays
{ nixpkgs-stable, nixpkgs-unstable, nixpkgsConfig, ... }@args: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; lib = args.lib; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  packages-channels = final: _prev: {
    unstable = import nixpkgs-unstable {
      inherit (final) system;
      config = nixpkgsConfig;
    };
    stable = import nixpkgs-stable {
      inherit (final) system;
      config = nixpkgsConfig;
    };
  };
}
