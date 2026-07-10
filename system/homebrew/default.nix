{ ... }: {
  nix-homebrew = {
    enable = true;
    user = "peter";
    autoMigrate = false;
  };
}
