{ ... }: {
  home.username = "peter";
  home.homeDirectory = "/Users/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  imports = [
    ./bat
    ./direnv
    ./ripgrep
    ./tmux
    ./zsh
  ];
}
