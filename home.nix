{ lib, ... }: {
  home.username = "peter";
  home.homeDirectory = "/Users/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  imports = [
    ./alacritty
    ./aws
    ./bat
    ./cloudflared
    ./delta
    ./direnv
    ./duckdb
    ./dust
    ./eza
    ./fclones
    ./fd
    ./ffmpeg
    ./fzf
    ./gcloud
    ./gh
    ./go
    ./gws
    ./jj
    ./jq
    ./just
    ./node
    ./nvim
    ./op
    ./pnpm
    ./postgres
    ./procs
    ./pyenv
    ./ripgrep
    ./rust
    ./sqlite
    ./sway
    ./syncthing
    ./tmux
    ./tokei
    ./uv
    ./yq
    ./zoxide
    ./zsh
    ./zstd
  ];
}
