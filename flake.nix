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
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... }: {
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
        ./gce.nix
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
