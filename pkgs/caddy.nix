{ pkgs
, lib
, stdenv
, fetchFromGitHub
, installShellFiles
, plugins
}:
let 
  version = "2.7.6";
  dist = fetchFromGitHub {
    owner = "caddyserver";
    repo = "dist";
    rev = "v${version}";
    hash = "sha256-aZ7hdAZJH1PvrX9GQLzLquzzZG3LZSKOvt7sWQhTiR8=";
  };
in
  stdenv.mkDerivation rec {
  pname = "caddy";
  # https://github.com/NixOS/nixpkgs/issues/113520
  inherit version;
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.git pkgs.go pkgs.xcaddy installShellFiles ];

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
  '';

  buildPhase =
    let
      pluginArgs =
        lib.concatMapStringsSep " " (plugin: "--with ${plugin}") plugins;
    in
    ''
      runHook preBuild
      ${pkgs.xcaddy}/bin/xcaddy build "v${version}" ${pluginArgs}
      runHook postBuild
    '';

  postInstall = ''
    install -Dm644 ${dist}/init/caddy.service ${dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service --replace "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service --replace "/usr/bin/caddy" "$out/bin/caddy"

    $out/bin/caddy manpage --directory manpages
    installManPage manpages/*

    installShellCompletion --cmd caddy \
      --bash <($out/bin/caddy completion bash) \
      --fish <($out/bin/caddy completion fish) \
      --zsh <($out/bin/caddy completion zsh)
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv caddy $out/bin
    runHook postInstall
  '';
}
