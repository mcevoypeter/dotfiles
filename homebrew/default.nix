{ ... }: {
  nix-homebrew = {
    enable = true;
    user = "peter";

    # An existing Homebrew install lives at /usr/local. Let nix-homebrew
    # take it over on first activation, keeping already-installed packages.
    autoMigrate = true;
  };
}
