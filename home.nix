{ pkgs, lib, graphical ? true, ... }: {
  home.username = "peter";
  # Shared across darwin + linux; only the home root differs by platform.
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/peter" else "/home/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  imports = [
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
    ./gcc
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
    ./syncthing
    ./tailscale
    ./tmux
    ./tokei
    ./uv
    ./yq
    ./zoxide
    ./zsh
    ./zstd
  ]
  # GUI-only modules — skipped on headless hosts (graphical = false).
  ++ lib.optionals graphical [
    ./alacritty
    ./sway
  ];
}
