{pkgs, config, username, ...}: let
  unstable-packages = with pkgs.unstable; [
    neofetch

    gnupg

    fzf
    eza
    # bat

    fd
    (ripgrep.override {withPCRE2 = true;})
    jq

    #-- c/c++
    cmake
    cmake-language-server
    gnumake
    checkmake
    # c/c++ compiler, required by nvim-treesitter!
    gcc
    gdb
    # c/c++ tools with clang-tools, the unwrapped version won't
    # add alias like `cc` and `c++`, so that it won't conflict with gcc
    llvmPackages.clang-unwrapped
    lldb
  ];

  stable-packages = with pkgs; [
    # core languages
    # rustup
    # go
    # lua
    # nodejs
    # python3
    # typescript

    # rust stuff
    # cargo-cache
    # cargo-expand

    # local dev stuf
    # mkcert
    # httpie

    # treesitter
    # tree-sitter

    # language servers
    # ccls # c / c++
    # gopls
    # nodePackages.typescript-language-server
    # pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    # nodePackages.yaml-language-server
    # sumneko-lua-language-server
    # nil # nix
    # nodePackages.pyright

    # formatters and linters
    alejandra # nix
    # black # python
    # ruff # python
    # deadnix # nix
    # golangci-lint
    # lua52Packages.luacheck
    # nodePackages.prettier
    # shellcheck
    # shfmt
    # statix # nix
    # sqlfluff
    # tflint
  ];
  cache = config.xdg.cacheHome;
in 
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    sessionVariables.VISUAL = "nvim";
    sessionVariables.PAGER = "less";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
    sessionVariables.LESSHISTFILE = cache + "/less/history";

    language.base = "en_US.UTF-8";

    packages = stable-packages ++ unstable-packages;

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "23.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };
    nix-index-database.comma.enable = true;

    eza = {
      enable = true;
      package = pkgs.unstable.eza;
      enableZshIntegration = true;
      git = true;
      icons = true;
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    fzf.enable = true;
    fzf.package = pkgs.unstable.fzf;
    fzf.enableZshIntegration = true;

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;
  };
}
