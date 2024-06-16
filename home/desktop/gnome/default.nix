{
  pkgs,
  config,
  lib,
  # anyrun,
  ...
} @ args:
with lib; let
  cfg = config.modules.desktop.gnome;
in {
  imports = [
  ];

  options.modules.desktop.gnome = {
    enable = mkEnableOption "gnome desktop environment";
  };

  config = mkIf cfg.enable ({
    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        # {
        #   package = dash-to-panel;
        # }
      ];
    };
    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
      };
    };
  });
}
