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

  # Enable in-memory compressed devices and swap space provided by the zram kernel module.
  # By enable this, we can store more data in memory instead of fallback to disk-based swap devices directly,
  # and thus improve I/O performance when we have a lot of memory.
  #
  #   https://www.kernel.org/doc/Documentation/blockdev/zram.txt
  zramSwap = {
    enable = lib.mkDefault true;
    # one of "lzo", "lz4", "zstd"
    algorithm = "zstd";
    # Priority of the zram swap devices.
    # It should be a number higher than the priority of your disk-based swap devices
    # (so that the system will fill the zram swap devices before falling back to disk swap).
    priority = 5;
    # Maximum total amount of memory that can be stored in the zram swap devices (as a percentage of your total memory).
    # Defaults to 1/2 of your total RAM. Run zramctl to check how good memory is compressed.
    # This doesn’t define how much memory will be used by the zram swap devices.
    memoryPercent = 50;
  };

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
