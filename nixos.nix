# nixos.nix — general NixOS config for Peter's machines; the NixOS counterpart to
# darwin.nix. Everything here is host-agnostic — GCE/host-specific bits (hardware,
# bootloader, console, networking) live in gce.nix. Paired with the shared
# ./home.nix via home-manager (see flake.nix).
{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];

  # Nix: flakes on, sensible GC.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  boot.tmp.cleanOnBoot = true;

  # Access path #1: Tailscale (primary; tailnet SSH).
  services.tailscale.enable = true;
  systemd.services.tailscale-ssh-advertise = {
    description = "Keep Tailscale SSH advertised";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Type = "oneshot"; RemainAfterExit = true; };
    script = ''${pkgs.tailscale}/bin/tailscale set --ssh || true'';
  };

  # Access path #2: openssh, key-only. Add per-host keys, or rely on Tailscale SSH.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "prohibit-password";
  };
  users.users.root.openssh.authorizedKeys.keys = lib.mkDefault [ ];

  # Primary user — matches home.nix's home-manager user (home /home/peter).
  users.users.peter = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false;

  # zsh as the login shell. System-level enable adds it to /etc/shells + the
  # base zsh setup; the actual zsh config comes from home-manager's ./zsh module.
  programs.zsh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # FHS loader: prebuilt dynamically-linked binaries (uv's CPython, native wheels,
  # Playwright/Chromium, ...) need a standard ELF interpreter on NixOS.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib zlib openssl curl glibc
    nss nspr dbus atk cups libdrm mesa
    alsa-lib pango cairo glib expat
    xorg.libX11 xorg.libXcomposite xorg.libXext
    xorg.libXdamage xorg.libXfixes xorg.libxcb xorg.libXrandr
  ];

  environment.systemPackages = with pkgs; [
    git vim curl wget htop tmux just ripgrep fd jq uv gh
  ];

  time.timeZone = "Etc/UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # The NixOS release this host targets; do NOT bump on upgrades.
  system.stateVersion = "25.11";
}
