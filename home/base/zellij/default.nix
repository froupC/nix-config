let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };
  home.shellAliases = shellAliases;

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
