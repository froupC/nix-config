{config, pkgs, lib, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    history.size = 10000;
    history.save = 10000;
    history.expireDuplicatesFirst = true;
    history.ignoreDups = true;
    history.ignoreSpace = true;
    historySubstringSearch.enable = true;

    plugins = [
      {
	      name = "fzf-tab";
	      src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
	    }
      {
        name = "fzf-tab-source";
        src = pkgs.fetchFromGitHub {
          owner = "Freed-Wu";
          repo = "fzf-tab-source";
          rev = "63ba0b98e506da29dcc1bcf0f48525e69c0a5c47";
	        sha256 = "sha256-nYJVDm44BKK/dgugLdW7lPgggGxEV91slk8sth7BgvM=";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];

    shellAliases = {
      "..." = "./..";
      "...." = "././..";
      gc = "nix-collect-garbage --delete-old";
      refresh = "source ${config.home.homeDirectory}/.zshrc";
      show_path = "echo $PATH | tr ':' '\n'";
    };

    envExtra = ''
  # Paths
      # Ensure path arrays do not contain duplicates.
      typeset -gU cdpath fpath mailpath path
      
      # Set the list of directories that cd searches.
      # cdpath=(
      #   $cdpath
      # )
      
      # Set the list of directories that Zsh searches for programs.
      path=(
        $HOME/{,s}bin(N)
        $HOME/.local/{,s}bin(N)
        /opt/{homebrew,local}/{,s}bin(N)
        /usr/local/{,s}bin(N)
        $path
      )
      
      # Less
      # Set the default Less options.
      # Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
      # Remove -X to enable it.
      if [[ -z "$LESS" ]]; then
        export LESS='-g -i -M -R -S -w -X -z-4'
      fi
      
      # Set the Less input preprocessor.
      if [[ -z "$LESSOPEN" ]]; then
        export LESSOPEN="|$HOME/.lessfilter %s" # set default lessfilter
        # export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
      fi
    '';

    initExtra = ''
      bindkey '^p' up-line-or-search
      bindkey '^n' down-line-or-search
      bindkey '^e' end-of-line
      bindkey '^w' forward-word
      bindkey "^[[3~" delete-char
      bindkey ";5C" forward-word
      bindkey ";5D" backward-word

      # Complete . and .. special directories
      zstyle ':completion:*' special-dirs true

      # disable named-directories autocompletion
      zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

      # Use caching so that commands like apt and dpkg complete are useable
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

      # Don't complete uninteresting users
      zstyle ':completion:*:*:*:users' ignored-patterns \
              adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
              clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
              gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
              ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
              named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
              operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
              rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
              usbmux uucp vcsa wwwrun xfs '_*'
      # ... unless we really want to.
      zstyle '*' single-ignored complete

      # https://thevaluable.dev/zsh-completion-guide-examples/
      zstyle ':completion:*' group-name ""
      # zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
      zstyle ':completion:*' squeeze-slashes true

      # use fzf-tab for universal completion
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      zstyle ':fzf-tab:*' fzf-flags "--preview-window=top,40%,wrap" # adjust layout for fzf-tab plugin
      
      # give a preview of commandline arguments when completing `kill`
      zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
        '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

      # mkcd is equivalent to takedir
      function mkcd takedir() {
        mkdir -p $@ && cd ''${@:$#}
      }

      function takeurl() {
        local data thedir
        data="$(mktemp)"
        curl -L "$1" > "$data"
        tar xf "$data"
        thedir="$(tar tf "$data" | head -n 1)"
        rm "$data"
        cd "$thedir"
      }

      function takegit() {
        git clone "$1"
        cd "$(basename ''${1%%.git})"
      }

      function take() {
        if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
          takeurl "$1"
        elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
          takegit "$1"
        else
          takedir "$@"
        fi
      }

      WORDCHARS='*?[]~=&;!#$%^(){}<>'

      # fixes duplication of commands when using tab-completion
      export LANG=C.UTF-8
    '';
  };
  programs.zsh.autosuggestion.enable = true;
  home.file.".lessfilter"= {
    source = ./lessfilter.sh;
    executable = true;
  };
}
