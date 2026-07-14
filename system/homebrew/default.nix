{ ... }: {
  nix-homebrew = {
    enable = true;
    user = "peter";
    autoMigrate = false;
  };

  # Declarative Brewfile — for macOS GUI apps that have no good nixpkgs build.
  homebrew = {
    enable = true;
    casks = [
      "vlc"
    ];
  };
}
