{
  lib,
  pkgs,
  ...
}: {
  ###################################################################################
  #
  #  NixOS's core configuration suitable for all my machines
  #
  ###################################################################################

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];
  environment.shells = [pkgs.bashInteractive pkgs.zsh];

  environment.enableAllTerminfo = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    parted
    psmisc # killall/pstree/prtstat/fuser/...

    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

    bashInteractive
    zsh

    wget
    curl
    aria2

    git # used by nix flakes
    git-lfs # used by huggingface models
    git-crypt

    coreutils
    gnugrep
    gnused
    gawk
    gnumake
    gnutar

    tree
    which
    file
    zstd
    rsync

    unzip
    zip
    xz

    # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (
      let
        base = pkgs.appimageTools.defaultFhsEnvArgs;
      in
        pkgs.buildFHSUserEnv (base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = ["dev"];
          })
    )
  ];

  # replace default editor with neovim
  environment.variables.EDITOR = "nvim";
}
