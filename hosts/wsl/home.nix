{
  nix-index-database,
  ...
}: {
  imports = [
    nix-index-database.hmModules.nix-index
    ../../home/wsl.nix
  ];
}
