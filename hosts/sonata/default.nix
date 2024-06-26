{
  username,
  hostname,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [
    (import ./win32yank.nix {inherit pkgs;})
  ];

  system.stateVersion = "23.11";

  users.users."${username}".linger = true;

  wsl = {
    enable = true;
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    wslConf.network.generateResolvConf = true;
    defaultUser = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  # FIXME: uncomment the next block to make vscode running in Windows "just work" with NixOS on WSL
  # solution adapted from: https://github.com/K900/vscode-remote-workaround
  # more information: https://github.com/nix-community/NixOS-WSL/issues/238 and https://github.com/nix-community/NixOS-WSL/issues/294
  # systemd.user = {
  #   paths.vscode-remote-workaround = {
  #     wantedBy = ["default.target"];
  #     pathConfig.PathChanged = "%h/.vscode-server/bin";
  #   };
  #   services.vscode-remote-workaround.script = ''
  #     for i in ~/.vscode-server/bin/*; do
  #       echo "Fixing vscode-server in $i..."
  #       ln -sf ${pkgs.nodejs_18}/bin/node $i/node
  #     done
  #   '';
  # };

}
