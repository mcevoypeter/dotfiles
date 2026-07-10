{ lib, ... }: {
  imports = [ ./homebrew ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "1password-cli"
    ];
  system.stateVersion = 5;
  users.users.peter = {
    name = "peter";
    home = "/Users/peter";
  };
}
