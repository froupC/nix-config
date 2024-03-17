{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      format=''$os$shell$username$hostname$localip$shlvl$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$pijul_channel$docker_context$package$c$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$memory_usage$aws$gcloud$openstack$azure$env_var$crystal$custom$sudo$cmd_duration$line_break$jobs$battery$time$status$container$character'';
      os.disabled = false;
      os.symbols = {
        Arch = "󰣇 ";
        Macos = "󰀵 ";
        NixOS = "󱄅 ";
        Ubuntu = "󰕈 ";
        Windows = "󰖳 ";
      };
      shell.disabled = false;
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = false;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };
  };
}
