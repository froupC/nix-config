{config, pkgs, lib, ...}: {
  # security with polkit
  # security.polkit.enable = true;
  # security with gnome-kering
  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.greetd.enableGnomeKeyring = true;

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = (lib.mkDefault pkgs.pinentry-curses);
    enableSSHSupport = false;
  };
}
