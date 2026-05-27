#!/usr/bin/env bash

case $(uname -s) in
  "Darwin")
    # Tmux 3.5a is broken on Alacritty + macOS at the time of writing (27 Jan 2025).
    brew install neovim pyenv
    ;;
  "Linux")
    sudo apt-get update

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

ln -sf $(pwd)/nvim                        $HOME/.config
