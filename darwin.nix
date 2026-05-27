{ ... }: {
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
  users.users.peter = {
    name = "peter";
    home = "/Users/peter";
  };
}
