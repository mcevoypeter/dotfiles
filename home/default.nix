{ pkgs, lib, graphical ? true, ... }: {
  home.username = "peter";
  # Shared across darwin + linux; only the home root differs by platform.
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/peter" else "/home/peter";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  # Config-bearing modules — each lives in its own directory next to this file.
  imports = [
    ./bat
    ./direnv
    ./jj
    ./nvim
    ./ripgrep
    ./syncthing
    ./tmux
    ./zoxide
    ./zsh
  ]
  # GUI-only modules — skipped on headless hosts (graphical = false).
  ++ lib.optionals graphical [
    ./alacritty
    ./paneru
    ./sway
  ];

  # Tools installed with no extra configuration — just the binary on PATH.
  # Anything that carries real config gets its own module in the imports above.
  # Trailing comment == the tool's name where it differs from the nixpkgs attr.
  home.packages = with pkgs; [
    awscli2           # aws
    cloudflared
    delta
    duckdb
    dust
    eza
    fclones
    fd
    ffmpeg
    fzf
    gcc
    google-cloud-sdk  # gcloud
    gh
    git-lfs
    go
    gws
    jq
    just
    gnumake           # make
    nodejs            # node
    _1password-cli    # op
    pnpm
    postgresql        # postgres
    procs
    pyenv
    rustup            # rust
    sqlite
    tailscale
    tokei
    uv
    yq
    zstd
  ];
}
