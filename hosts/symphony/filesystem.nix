{
  config,
  pkgs,
  lib,
  username,
  impermanence,
  disko,
  ...
}: {
  imports = [
    impermanence.nixosModules.impermanence
    disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 0;
              name = "ESP";
              size = "2G";
              type = "C12A7328-F81F-11D2-BA4B-00A0C93EC93B";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };
            nix = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress-force=zstd" "nosuid" "nodev" "noatime" ];
                  };
                  "@persist" = {
                    mountpoint = "/nix/persist";
                    mountOptions = [ "compress-force=zstd" "nosuid" "nodev" "noatime" ];
                  };
                  "@swap" = {
                    mountpoint = "/.swap";
                    mountOptions = [ "noatime" ];
                    swap = {
                      swapfile = {
                        size = "16G";
                        path = "swapfile";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };

      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [ "relatime" "mode=755" "nosuid" "nodev" ];
      };
    };
  };

  # fileSystems = {
  #   "/" = {
  #     device = "tmpfs";
  #     fsType = "tmpfs";
  #     options = ["relatime" "mode=755" "nosuid" "nodev"];
  #   };
  #   "/boot" = {
  #     device = "/dev/disks/by-uuid/uuid";
  #     fsType = "vfat";
  #     options = ["fmask=0077" "dmask=0077"];
  #   };
  #   "/nix" = {
  #     device = "/dev/disks/by-uuid/uuid";
  #     fsType = "btrfs";
  #     options = ["compress-force=zstd" "nosuid" "nodev" "subvol=@nix"];
  #   };
  #   "/nix/persistent" = {
  #     neededForBoot = true;
  #     device = "/dev/disks/by-uuid/uuid";
  #     fsType = "btrfs";
  #     options = ["compress-force=zstd" "nosuid" "nodev" "subvol=@persistent"];
  #   };
  #   "/.swap" = {
  #     device = "/dev/disks/by-uuid/uuid";
  #     fsType = "btrfs";
  #     options = ["subvol=@swap" "ro"];
  #   };
  #   "/.swap/swapfile" = {
  #     # the swapfile is located in /swap subvolume, so we need to mount /swap first.
  #     depends = ["/swap"];
  #
  #     device = "/.swap/swapfile";
  #     fsType = "none";
  #     options = ["bind" "rw"];
  #   };
  # };

  environment.persistence."/nix/persistent" = {
    hideMounts = true;

    directories = [
      "/etc/NetworkManager/system-connections"
      "/root"
      "/var"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];

    users.${username} = {
      directories = [
        "src"
        "containers"
        "services"
        # configs
        ".cache"
        ".config"
        ".gnupg"
        ".local"
        ".ssh"
      ];
      files = [ ];
    };
  };

  systemd.services.nix-daemon = {
    environment = {
      # make nix daemon build in this directory instead of /tmp
      TMPDIR = "/var/cache/nix";
    };
    serviceConfig = {
      # auto create /var/cache/nix
      CacheDirectory = "nix";
    };
  };
  # make root nix command use daemon
  environment.variables.NIX_REMOTE = "daemon";
}
