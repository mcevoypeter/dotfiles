# gce.nix — GCE/host-specific NixOS config for `gce-arm`, the aarch64 VM in
# project gcp-project. Everything here is tied to this cloud host: hardware
# (disk/initrd), UEFI bootloader, serial console, and networking. Host-agnostic
# config lives in nixos.nix. Both are composed in flake.nix.
{ modulesPath, lib, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # ---- Hardware (captured from the live box; mount by-UUID) ----
  #   /dev/nvme0n1 (GCE NVMe, GPT): p1 ext4 "/", p15 vfat "/boot/efi".
  boot.initrd.availableKernelModules = [ "nvme" "virtio_pci" "virtio_blk" "virtio_scsi" "xhci_pci" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
    fsType = "ext4";
    options = [ "discard" ];
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/0000-0000";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # ---- Bootloader: GRUB-EFI, "removable" install (no NVRAM writes) ----
  # GCE arm64 firmware boots the UEFI fallback \EFI\BOOT\BOOTAA64.EFI, so
  # efiInstallAsRemovable + canTouchEfiVariables=false is the reliable path.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.timeout = 3;

  # arm64 GCE uses the PL011 UART (ttyAMA0). ttyAMA0 LAST = primary console, so
  # the GCP serial console captures the full systemd boot log + emergency shell.
  boot.kernelParams = [ "console=tty1" "console=ttyAMA0,115200n8" ];

  # ---- Networking: systemd-networkd + resolved ----
  # NOT NixOS scripted dhcpcd: its sandbox (ProtectSystem=strict +
  # ReadWritePaths=/etc/resolv.conf) dies with status=226/NAMESPACE when
  # /etc/resolv.conf dangles at the resolved stub. networkd + resolved avoids it.
  networking.hostName = "gce-arm";
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
