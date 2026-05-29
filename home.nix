{ lib, ... }: {
  home.username = "peter";
  home.homeDirectory = "/Users/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  imports = [
    ./alacritty
    ./aws
    ./bat
    ./delta
    ./direnv
    ./dust
    ./eza
    ./fclones
    ./fd
    ./fzf
    ./gcloud
    ./go
    ./jj
    ./just
    ./node
    ./nvim
    ./procs
    ./pyenv
    ./ripgrep
    ./rust
    ./sway
    ./tmux
    ./tokei
    ./zoxide
    ./zsh
  ];
}
