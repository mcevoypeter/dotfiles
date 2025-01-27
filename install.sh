#!/usr/bin/env bash

which cargo || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-binstall

cargo binstall bat du-dust eza fclones fd-find git-delta just procs ripgrep tokei zoxide

case $(uname -s) in
  "Darwin")
    # Tmux 3.5a is broken on Alacritty + macOS at the time of writing (27 Jan 2025).
    brew install direnv fzf neovim tmux/tmux.rb && brew pin tmux
    ;;
  "Linux")
    sudo apt-get update && sudo apt-get install direnv fzf neovim tmux
    ;;
esac

ln -sf $(pwd)/aider/aider.conf.yml        $HOME/.aider.conf.yml
ln -sf $(pwd)/alacritty                   $HOME/.config
ln -sf $(pwd)/bat                         $HOME/.config
ln -sf $(pwd)/direnv                      $HOME/.config
ln -sf $(pwd)/nvim                        $HOME/.config
ln -sf $(pwd)/ripgrep                     $HOME/.config
ln -sf $(pwd)/starship/starship.toml      $HOME/.config
ln -sf $(pwd)/tmux/tmux.conf              $HOME/.tmux.conf
ln -sf $(pwd)/zsh/zsh-syntax-highlighting $HOME/.zsh-syntax-highlighting
ln -sf $(pwd)/zsh/zshrc                   $HOME/.zshrc
ln -sf $(pwd)/zsh/zprofile                $HOME/.zprofile
