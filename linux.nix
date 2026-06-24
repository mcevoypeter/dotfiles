{ lib, ... }: {
  # NixOS system config for Peter's Linux machines — the counterpart to darwin.nix,
  # paired with the shared ./home.nix via home-manager (see flake.nix).
  #
  # Deliberately portable: host-specific hardware (bootloader, fileSystems,
  # networking) and per-host services are NOT here yet. The live `nixos-vm1`
  # system config still lives in realismlabs/peter:nixos/ — consolidating it here
  # is punted. To make this deployable to a concrete host, add that host's
  # hardware-configuration.nix to the flake's nixosConfigurations modules.

  nixpkgs.hostPlatform = "aarch64-linux";
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # FHS dynamic loader so prebuilt, dynamically-linked binaries (uv's CPython,
  # native wheels, etc.) run on NixOS.
  programs.nix-ld.enable = true;

  users.users.peter = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.11";
}
