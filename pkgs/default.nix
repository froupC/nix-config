# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs, lib }: {
  # example = pkgs.callPackage ./example { };
  customized_caddy = pkgs.callPackage ./caddy.nix {
    plugins = [
      "github.com/WeidiDeng/caddy-cloudflare-ip"
    ];
  };

  clash2sfa = pkgs.callPackage ./clash2sfa.nix;
}
