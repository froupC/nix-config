{ lib, buildGoModule, fetchFromGitHub }:
with lib; buildGoModule rec {
  pname = "clash2sfa";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "xmdhs";
    repo = pname;
    # https://github.com/NixOS/nixpkgs/blob/nixos-21.11/pkgs/servers/caddy/default.nix
    rev = "v${version}";
    hash = "sha256-K8PHOiuwyxtuAs/twmEPUN4lcxROwbKVRmAl5GAEHq0=";
  };

  vendorHash = "sha256-IEe5+VQmBsleqZx6X9Te6l71M2zBp8nfMj+ni4/7uoU=";

  postPatch = ''
    sed -i 's/port := ":8080"/port := ":5149"/' main.go
  '';

  meta = {
    homepage = "https://github.com/xmdhs/clash2sfa";
    description = "Convert clash style subscription to sing-box style";
    license = licenses.mit;
  };
}
