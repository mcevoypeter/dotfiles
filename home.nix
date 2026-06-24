{ pkgs, ... }: {
  home.username = "peter";
  # Shared across darwin + linux; only the home root differs by platform.
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/peter" else "/home/peter";
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
    ./git-lfs
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
    ./tailscale
    ./tmux
    ./tokei
    ./uv
    ./yq
    ./zoxide
    ./zsh
    ./zstd
  ];
}
