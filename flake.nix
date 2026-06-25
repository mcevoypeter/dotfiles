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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, disko, ... }: {
    # Mac.
    darwinConfigurations."darwin" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { graphical = true; };
          home-manager.users.peter = import ./home.nix;
        }
      ];
    };

    # gce-arm.
    nixosConfigurations."gce-arm" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./nixos.nix
        ./gce-aarch64.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { graphical = false; };
          home-manager.users.peter = import ./home.nix;
        }
      ];
    };

    # gce-x86 — Intel x86 VM with nested virtualization enabled;
    # the x86_64 sibling of gce-arm. /dev/kvm works here, so Firecracker boots.
    nixosConfigurations."gce-x86" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos.nix
        ./gce-x86_64.nix
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { graphical = false; };
          home-manager.users.peter = import ./home.nix;
        }
      ];
    };
  };
}
