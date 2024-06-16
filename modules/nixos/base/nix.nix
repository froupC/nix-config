{
  lib,
  nur,
  nixpkgs,
  username,
  fullUsername,
  nixpkgs-unstable,
  nixpkgs-stable,
  ...
}: 
let 
  nixpkgsConfig = {
    allowUnfree = true;
    permittedInsecurePackages = [];
  };
  overlays = import ../../../overlays { inherit nixpkgs-stable nixpkgs-unstable nixpkgsConfig lib; };
in 
{
  nixpkgs = {
    config = nixpkgsConfig;
    overlays = [ nur.overlay ] ++ [
      overlays.additions
      overlays.modifications
      overlays.packages-channels
    ];
  };

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = [username];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;
  };

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Manual optimise storage: nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  programs.nix-ld.enable = true;
}
