{config, ...}: {
  programs.ssh.startAgent = true;
  programs.ssh.extraConfig = ''
  Host github.com
      Hostname ssh.github.com
      Port 443
      User git
  '';
  # nix.extraOptions = ''
  #   !include ${config.age.secrets.nix-access-tokens.path}
  # '';
}
