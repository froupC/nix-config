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

  disko = {
    enableConfig = false;

    devices = {
      disk.main = {
        type = "disk";
        device = "/dev/vda";
        imageSize = "2G";
        content = {
          type = "gpt";
          partitions = {
            bios = {
              size = "1M";
              type = "21686148-6449-6E6F-744E-656564454649"; # BIOS boot partition
              priority = 0;
            };

            boot = {
              size = "1G";
              type = "C12A7328-F81F-11D2-BA4B-00A0C93EC93B";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };

            nix = {
              size = "100%";
              priority = 2;
              content = {
                # type = "filesystem";
                # format = "btrfs";
                # mountpoint = "/nix";
                # mountOptions = ["compress-force=zstd" "nosuid" "nodev"];
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@" = {};
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress-force=zstd" "nosuid" "nodev" "noatime" ];
                  };
                  "@persistent" = {
                    mountpoint = "/nix/persistent";
                    mountOptions = [ "compress-force=zstd" "nosuid" "nodev" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };

      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = ["relatime" "mode=755" "nosuid" "nodev"];
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["relatime" "mode=755" "nosuid" "nodev"];
    };
    "/boot" = {
      device = "/dev/sda2";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
    "/nix" = {
      device = "/dev/sda3";
      fsType = "btrfs";
      options = ["compress-force=zstd" "nosuid" "nodev" "subvol=@nix"];
    };
    "/nix/persistent" = {
      neededForBoot = true;
      device = "/dev/sda3";
      fsType = "btrfs";
      options = ["compress-force=zstd" "nosuid" "nodev" "subvol=@persistent"];
    };
  };

  environment.persistence."/nix/persistent" = {
    hideMounts = true;

    directories = [
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
