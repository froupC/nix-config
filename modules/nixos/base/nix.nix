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
  overlays = import ../../../overlays { inherit nixpkgs-stable nixpkgs-unstable nixpkgsConfig; };
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

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;

  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.

  # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
  # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

  nix.nixPath = [
    "nixpkgs=${nixpkgs.outPath}"
    "nixos-config=/etc/nixos/configuration.nix"
    # "/nix/var/nix/profiles/per-user/root/channels"
  ];

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
