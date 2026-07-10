{
  description = "Peter's machine config";

  inputs = {
    # Everything tracks the current stable NixOS release — no nixpkgs-unstable.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Sliding, tiling window manager for macOS (the darwin analog of ./home/sway).
    # Exposes homeModules.paneru, wired into every home-manager user below.
    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, nixvim, disko, paneru, ... }:
    let
      hm = graphical: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit graphical; };
        # Make `programs.nixvim` (./home/nvim) and `services.paneru` (./home/paneru)
        # available to every home-manager user.
        home-manager.sharedModules = [ nixvim.homeModules.nixvim paneru.homeModules.paneru ];
        home-manager.users.peter = import ./home;
      };
    in {
      # Generic, machine-agnostic configs. Each machine's real identity
      # (networking.hostName, etc.) is supplied by its OWN local, untracked
      # entrypoint — never committed here:
      #   * NixOS host: /etc/nixos/flake.nix builds
      #       dotfiles.nixosConfigurations.gce-x86.extendModules
      #         { modules = [ { networking.hostName = "<name>"; } ]; }
      #   * macOS:      apply.sh builds .#$HOST, with HOST set in .envrc.local.
      darwinConfigurations.darwin = nix-darwin.lib.darwinSystem {
        modules = [
          ./system/darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          (hm true)
        ];
      };

      nixosConfigurations.gce-x86 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/nixos.nix
          ./system/gce-x86_64.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          (hm false)
        ];
      };
    };
}
