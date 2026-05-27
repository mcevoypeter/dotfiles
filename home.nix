{ ... }: {
  home.username = "peter";
  home.homeDirectory = "/Users/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  imports = [
    ./alacritty
    ./bat
    ./direnv
    ./ripgrep
    ./tmux
    ./zsh
  ];
}
