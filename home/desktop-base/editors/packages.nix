{pkgs, ...}: {
  nixpkgs.config = {
    programs.npm.npmrc = ''
      prefix = ''${HOME}/.npm-global
    '';
  };

  home.packages = with pkgs;
    [
      #-- python
      pyright # python language server
      (python3.withPackages (
        ps:
          with ps; [
            ruff-lsp
            black # python formatter

            jupyter
            ipython
            pandas
            requests
            pyquery
            pyyaml
          ]
      ))

      #-- rust
      rust-analyzer
      cargo # rust package manager
      rustc
      rustfmt

      #-- nix
      nil
      # nixd
      statix # Lints and suggestions for the nix programming language
      deadnix # Find and remove unused code in .nix source files
      alejandra # Nix Code Formatter

      #-- golang
      go
      gomodifytags
      iferr # generate error handling code for go
      impl # generate function implementation for go
      gotools # contains tools like: godoc, goimports, etc.
      gopls # go language server
      delve # go debugger

      # -- java
      jdk17
      gradle
      maven

      #-- lua
      stylua
      lua-language-server

      #-- bash
      nodePackages.bash-language-server
      shellcheck
      shfmt

      #-- javascript/typescript --#
      nodePackages.nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      # HTML/CSS/JSON/ESLint language servers extracted from vscode
      nodePackages.vscode-langservers-extracted
      nodePackages."@tailwindcss/language-server"
      emmet-ls

      #-- CloudNative
      nodePackages.dockerfile-language-server-nodejs
      jsonnet
      jsonnet-language-server
      hadolint # Dockerfile linter

      # -- Lisp like Languages
      racket-minimal
      fnlfmt # fennel

      #-- Others
      taplo # TOML language server / formatter / validator
      nodePackages.yaml-language-server
      sqlfluff # SQL linter
      actionlint # GitHub Actions linter
      buf # protoc plugin for linting and formatting
      proselint # English prose linter

      #-- Misc
      tree-sitter # common language parser/highlighter
      nodePackages.prettier # common code formatter
      marksman # language server for markdown
      glow # markdown previewer
      pandoc # document converter
      hugo # static site generator

      #-- Optional Requirements:
      gdu # disk usage analyzer, required by AstroNvim
    ];
}
