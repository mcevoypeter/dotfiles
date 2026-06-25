# gce-x86_64.nix — reusable module for an x86_64 (Intel) GCE NixOS host.
# Machine-agnostic: the host identity (networking.hostName) is supplied by the
# machine's local entrypoint flake, not here. Composed via nixosConfigurations.gce-x86.
#
# Assumes the GCE VM was created WITH nested virtualization enabled (Intel-only on
# GCE), so the kvm-intel module below yields a working /dev/kvm — Firecracker boots.
{ modulesPath, lib, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Expose /dev/kvm for nested virtualization (Firecracker / KVM). Only works
  # because the VM was created with --enable-nested-virtualization.
  boot.kernelModules = [ "kvm-intel" ];

  # ---- Disk layout — declarative via disko. nixos-anywhere partitions + formats
  # /dev/sda from this spec (GPT + UEFI): a 1G vfat ESP at /boot/efi + ext4 root.
  # disko generates the fileSystems.* entries, so they're not hand-written here.
  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" "virtio_pci" "virtio_scsi" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  swapDevices = [ ];
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/efi";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "discard" ];
          };
        };
      };
    };
  };

  # ---- Bootloader: GRUB-EFI, "removable" install (GCE UEFI firmware boots the
  # fallback \EFI\BOOT\BOOTX64.EFI). ----
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.timeout = 3;

  # x86 GCE serial console is ttyS0; LAST = primary console, so the GCP serial
  # console captures the full systemd boot log + emergency shell.
  boot.kernelParams = [ "console=tty1" "console=ttyS0,115200n8" ];

  # ---- Networking: systemd-networkd + resolved (GCE-generic) ----
  # networking.hostName is intentionally NOT set here — the local entrypoint sets it.
  networking.usePredictableInterfaceNames = false;   # NIC is eth0 on GCE
  networking.useDHCP = false;
  systemd.network.enable = true;
  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "eth0";
    networkConfig.DHCP = "yes";
    dhcpV4Config.UseMTU = true;             # honor GCE's 1460 MTU
    linkConfig.RequiredForOnline = "routable";
  };
  services.resolved.enable = true;
}
