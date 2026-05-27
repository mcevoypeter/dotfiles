{ lib, ... }: {
  home.username = "peter";
  home.homeDirectory = "/Users/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  imports = [
    ./alacritty
    ./bat
    ./delta
    ./direnv
    ./dust
    ./eza
    ./fclones
    ./fd
    ./fzf
    ./go
    ./jj
    ./just
    ./nvim
    ./procs
    ./ripgrep
    ./rust
    ./sway
    ./tmux
    ./tokei
    ./zoxide
    ./zsh
  ];
}
