{ config, pkgs, ...}: {
  boot.kernelParams = [
    "audit=0"
    "net.ifnames=0"
    "biosdevname=0"
  ];

  boot.initrd = {
    # compressor = "zstd";
    compressorArgs = ["-19" "-T0"];
    systemd.enable = true;
  };

  boot.loader.grub = {
    enable = true;
    devices = ["/dev/sda"];
  };

  boot.initrd.postDeviceCommands = with pkgs; lib.mkIf (!config.boot.initrd.systemd.enable) ''
    # Set the system time from the hardware clock to work around a
    # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
    # to the *boot time* of the host).
    hwclock -s
  '';

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
    "vmw_pvscsi"
    "virtio_net"
    "virtio_pci"
    "virtio_mmio"
    "virtio_blk"
    "virtio_scsi"
    "9p"
    "9pnet_virtio"
  ];

  boot.initrd.kernelModules = [
    "virtio_balloon"
    "virtio_console"
    "virtio_rng"
    "nvme"
  ];

  zramSwap.enable = true;
}
