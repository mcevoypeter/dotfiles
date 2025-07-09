#!/usr/bin/env bash

which cargo || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-binstall

cargo binstall bat du-dust eza fclones fd-find git-delta just procs ripgrep tokei zoxide

case $(uname -s) in
  "Darwin")
    # Tmux 3.5a is broken on Alacritty + macOS at the time of writing (27 Jan 2025).
    brew install direnv fzf go neovim pyenv tmux/tmux.rb && brew pin tmux
    ;;
  "Linux")
    sudo apt-get update && sudo apt-get install direnv fzf golang-go tmux

    # Install Neovim
    nvim_version=0.11.3
    nvim_archive=nvim-linux-x86_64
    wget -O $nvim_archive.tar.gz https://github.com/neovim/neovim/releases/download/v$nvim_version/nvim-linux-x86_64.tar.gz
    tar xzvf $nvim_archive.tar.gz
    sudo mv $nvim_archive /usr/local/nvim && sudo ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim
    rm -rf $nvim_archive && rm $nvim_archive.tar.gz

    # Install pyenv
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev \
      libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
      && (curl https://pyenv.run | bash)
    ;;
esac

ln -sf $(pwd)/aider/aider.conf.yml        $HOME/.aider.conf.yml
ln -sf $(pwd)/alacritty                   $HOME/.config
ln -sf $(pwd)/bat                         $HOME/.config
ln -sf $(pwd)/direnv                      $HOME/.config
ln -sf $(pwd)/himalaya                    $HOME/.config
ln -sf $(pwd)/nvim                        $HOME/.config
ln -sf $(pwd)/ripgrep                     $HOME/.config
ln -sf $(pwd)/starship/starship.toml      $HOME/.config
ln -sf $(pwd)/tmux/tmux.conf              $HOME/.tmux.conf
ln -sf $(pwd)/zsh/zsh-syntax-highlighting $HOME/.zsh-syntax-highlighting
ln -sf $(pwd)/zsh/zshrc                   $HOME/.zshrc
ln -sf $(pwd)/zsh/zprofile                $HOME/.zprofile
