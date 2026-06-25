# gce-x86_64.nix — GCE/host-specific NixOS config for `gce-x86`, the
# x86_64 (Intel) VM in project gcp-project; the x86 counterpart to gce-aarch64.nix.
# Host-agnostic config lives in nixos.nix. Both are composed in flake.nix.
#
# This host is an x86 VM created WITH nested virtualization enabled
# (`--enable-nested-virtualization`; n2 runs Cascade Lake+, already > Haswell). On GCE,
# nested virt is Intel-only, so unlike the aarch64 host the kvm-intel module
# below yields a working /dev/kvm — i.e. Firecracker actually boots here.
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
  # fallback \EFI\BOOT\BOOTX64.EFI), mirroring gce-aarch64.nix. ----
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

  # ---- Networking: systemd-networkd + resolved (GCE-generic; see gce-aarch64.nix) ----
  networking.hostName = "gce-x86";
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
