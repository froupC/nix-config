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
        imageSize = "3G";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "512M";
              type = "EF00";
              priority = 0;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0077" "dmask=0077"];
              };
            };

            nix = {
              size = "100%";
              priority = 1;
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/nix";
                mountOptions = ["compress-force=zstd" "nosuid" "nodev"];
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
    "/nix" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = ["compress-force=zstd" "nosuid" "nodev"];
    };
    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
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
